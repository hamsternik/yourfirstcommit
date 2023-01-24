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
    
    
    
    // Some baked repos fo quick switching for debug/development purposes
    private let predefinedRepos: [String] = ["tensorflow", "btop", "ahawker/ulid", "https://github.com/skanaar/nomnoml.git","r-ss/ress_notification_service.git"
    ]
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading, spacing: 6) {
                
                
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("Enter repository name:").font(.title3)
                    TextField("Enter text...", text: $repoName)
                        .disableAutocorrection(true).font(.system(.body, design: .monospaced))
                    
                }
                .background(Color.gray.opacity(0.25))
                .padding(.bottom)
                
                Text("Some predefined repos (for dev):").font(.title3)
                Picker("Predefined repos", selection: $repoName) {
                    ForEach(predefinedRepos, id: \.self) { item in
                        Text(item)
                    }
                }
                
                Button("Search!") {
                    githubApi.searchRepo(for_name: self.repoName)
                }
                
                if let results = githubApi.searchRepoResults {
                    Text("Results: \(results.total_count)")
                    List {
                        ForEach(results.items, id: \.self) { repoItem in
                            //Text(repoItem.full_name)
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

struct RepoNameField_Previews: PreviewProvider {
    
    @State static var githubApi = GithubApiService()
    
    static var previews: some View {
        RepoNameField().environmentObject(githubApi)
    }
}
