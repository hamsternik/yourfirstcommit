//
//  SearchResults.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 02.02.2023.
//

import SwiftUI

struct GitHubSearchResults: View {
    
    @State var results: SearchReposResults?
    
    var body: some View {
        VStack {
            
            if let results = self.results {
                
                List {
                    ForEach(results.items, id: \.self) { repoItem in
                        NavigationLink {
                            RepoView(repo: repoItem)
                        } label: {
                            Text(repoItem.full_name).padding(0)
                        }.listRowSeparator(.hidden).padding(0)
                    }
                }.listStyle(PlainListStyle())
                
            } else {
                Text("No repositories")
            }
            
        }
        .padding(0)
        .navigationBarTitle(Text("Search results"), displayMode: .inline)
    }
}

struct GitHubSearchResults_Previews: PreviewProvider {
    
    static let repo1 = Repo(id: 1, name: "repo1", full_name: "repo1", html_url: "url1")
    static let repo2 = Repo(id: 2, name: "repo2", full_name: "repo2", html_url: "url2")
    @State static var dummyResults = SearchReposResults(total_count: 2, incomplete_results: false, items: [repo1, repo2])
    
    static var previews: some View {
        GitHubSearchResults(results: dummyResults)
    }
}
