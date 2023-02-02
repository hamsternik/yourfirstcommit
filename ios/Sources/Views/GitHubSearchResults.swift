//
//  SearchResults.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 02.02.2023.
//

import SwiftUI

struct GitHubSearchResults: View {
    
    @State var results: SearchReposResults
    
    
    
//    init() {
//
//    }
//
//    init(by_user: Bool) {
//        if by_user == true {
//            _showUserCardsOnly = State(initialValue: true)
//        }
//
//    }
        
    
    var body: some View {
        NavigationView {
            VStack {
                List {

                    //                    if (self.filteredCards.count == 0) {
                    //                        Text("No cards, add some")
                    //                    }
                    ForEach(results.items) { item in
                        //NavigationLink {
                            
                        //} label: {
                        Text("Item: \(item.name)")
                        //}.listRowSeparator(.hidden)
                    }
                    
                    if (results.items.count == 0) {
                        Text("No items")
                    }
                    
                }.listStyle(PlainListStyle())
                
//                .navigationBarTitle(Text("Cards List"), displayMode: .inline)
//                .navigationBarItems(trailing: Button(action: {
//                    self.addMode = true
//                } ) {
//                    Image(systemName: "plus")
//                        .padding([.leading, .top, .bottom])
//                } )
                

            }
            .padding(0)
        }
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
