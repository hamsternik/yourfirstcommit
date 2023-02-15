//
//  RepoNameField.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct RepoNameField_Previews: PreviewProvider {
    static var previews: some View {
        RepoNameField()
    }
}

struct RepoNameField: View {
    
    @State var repoName: String = "hamsternik/yourfirstcommit"
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text("Enter repository name:")
            TextField("Enter text...", text: $repoName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true).font(.system(.body, design: .monospaced))
                .padding(.bottom)
            
            HStack (spacing: 10) {
                Button("Search") {
                    Task {
                        await startGithubSearch(for: self.repoName)
                    }
                }
                .buttonStyle(.bordered)
                
                Button("I'm Feeling Lucky") {
                    repoName = predefinedRepos.randomElement()!
                    Task {
                        await startGithubSearch(for: self.repoName)
                    }
                }
                .buttonStyle(.bordered)
            }
            
            NavigationLink(
                destination: GitHubSearchResults(results: self.foundRepos),
                isActive: $isActive
            ) { EmptyView() }
            
            if reposSearchInProgress {
                LoaderView()
            }
        }
    }
    
    // MARK: Private
    
    @State private var foundRepos:SearchReposResults? = nil
    @State private var isActive = false
    @State private var reposSearchInProgress: Bool = false
    
    
    // Some repos fo quick switching
    // by "I'm Feeling Lucky" button
    private let predefinedRepos: [String] = [
        "hamsternik/yourfirstcommit",
        "tensorflow",
        "btop",
        "ahawker/ulid",
        "nomnoml",
        "IKEv2-setup",
        "powerlevel10k",
        "spectre.css"
    ]
    
    private func startGithubSearch(for name: String) async {
        reposSearchInProgress = true
        Task(priority: .background) {
            let result = await GithubService().searchRepositories(name: name)
            switch result {
            case .success(let searchResponse):
                foundRepos = searchResponse
                isActive = true
                reposSearchInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                reposSearchInProgress = false
            }
        }
    }
}
