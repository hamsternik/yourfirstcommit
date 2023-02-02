//
//  RepoNameField.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI


struct RepoNameField: View {
    
    @State var repoName: String = "tensorflow"
    
    @EnvironmentObject var githubApi: GithubApiService
    
    @State private var isActive = false
    
    
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
    
//    private func startGithubSearch(for name: String) {
//        let results: SearchReposResults = githubApi.newSearchGithub(forRepo: name)
//    }
    
    
    
    var body: some View {
        GeometryReader { geometry in
        NavigationView {
            
            VStack(alignment: .center, spacing: 6) {
                
                
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Enter repository name:")
                    TextField("Enter text...", text: $repoName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true).font(.system(.body, design: .monospaced))
                        .background(Color.gray.opacity(0.25))
                    
                }
                
                .padding(.bottom)
                
                HStack (spacing: 10) {
                    Button("Search") {
                        githubApi.searchGithub(forRepo: self.repoName)
                    }.buttonStyle(.bordered)
                    
                    Button("I'm Feeling Lucky") {
                        repoName = predefinedRepos.randomElement()!
                        githubApi.searchGithub(forRepo: self.repoName)
                    }.buttonStyle(.bordered)
                }
                
//                NavigationLink(destination: GitHubSearchResults(results: githubApi.searchRepoResults), isActive: $isActive) { }
                
                
                if let results = githubApi.searchRepoResults {
//                    NavigationLink(destination: GitHubSearchResults(results: results), isActive: $isActive){}.hidden()
                    
                        
                    Text("Results: \(results.total_count)")
                    List {
                        ForEach(results.items, id: \.self) { repoItem in
                            NavigationLink {
                                RepoView(repo: repoItem)
                            } label: {
                                Text(repoItem.full_name).padding(0)
                            }.listRowSeparator(.hidden).padding(0)

                        }
                    }.listStyle(PlainListStyle())
                }
                
                if githubApi.searchRepoLoading {
                    LoaderView()
                }
                
                
            }
                
            }
        }
    }
}

struct RepoNameField_Previews: PreviewProvider {
    
    @State static var githubApi = GithubApiService()
    
    static var previews: some View {
        RepoNameField().environmentObject(githubApi)
    }
}
