//
//  SearchResults.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 02.02.2023.
//

import SwiftUI

struct GitHubSearchResults_Previews: PreviewProvider {
    static var previews: some View {
        let results = SearchReposResults(
            total_count: 2,
            incomplete_results: false,
            items: [.mocked.repo1, .mocked.repo2]
        )
        GitHubSearchResults(results: results)
    }
}

struct GitHubSearchResults: View {
    @State var results: SearchReposResults?
    
    var body: some View {
        VStack {
            if let results = results {
                List {
                    ForEach(results.items, id: \.self) { repo in
                        NavigationLink {
                            RepoView(repo: repo)
                        } label: {
                            Text(repo.fullName).padding(0)
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
