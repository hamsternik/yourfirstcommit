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
    @State var repoName: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Spacer()
            
            if reposSearchInProgress {
                LoaderView()
                    .padding(.bottom)
            }
            
            searchView
                .padding([.leading, .trailing])
                .padding(.bottom)
        }
        
        NavigationLink(
            destination: GitHubSearchResults(results: self.foundRepos),
            isActive: $isActive
        ) { EmptyView() }
    }
    
    // MARK: Private
    
    @State private var foundRepos:SearchReposResults? = nil
    @State private var isActive = false
    @State private var reposSearchInProgress: Bool = false
    
    private var searchView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("gray.light"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 1)
                )
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "magnifyingglass")
                    .frame(width: 44)
                    .foregroundColor(.gray)
                
                TextField("Search repository", text: $repoName)
                    .font(.system(.body))
                    .disableAutocorrection(true)
                    .padding(.bottom)
                    .offset(x: -16)
                    .submitLabel(.search)
                    .onSubmit {
                        startGithubSearch(for: self.repoName)
                    }
                
                Button {
                    repoName.removeAll()
                } label: {
                    Label(" ", systemImage: "xmark.circle.fill")
                        .frame(height: 44)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: 44)
    }
    
    // Some repos fo quick switching
    // by "I'm Feeling Lucky" button
    private let predefinedRepos: [String] = [
        "tensorflow",
        "btop",
        "ahawker/ulid",
        "nomnoml",
        "IKEv2-setup",
        "powerlevel10k",
        "spectre.css"
    ]
    
    private func startGithubSearch(for name: String) {
        reposSearchInProgress = true
        GithubApiService().newSearchGithub(forRepo: name) { (result, error) in
            if let repos = result {
                foundRepos = repos
                isActive = true
                reposSearchInProgress = false
            } else if let _ = error {
                //Handle or show this error somehow
                reposSearchInProgress = false
            }
        }
    }
}
