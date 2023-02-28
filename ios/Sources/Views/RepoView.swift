//
//  RepoView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RepoView(repo: .mocked.repo1)
        }
    }
}

struct RepoView: View {
    
    @State var repo: Repo
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 6) {
                    //Text(repo.name)
                    //.font(.title)
                    Text(repo.fullName)
                    
                    //Text("id: \(repo.id)")
                    if let repoURL = URL(string: repo.htmlUrl) {
                        Link(destination: repoURL) {
                            HStack {
                                Text("Open in browser")
                                Image(systemName: "link.circle.fill").resizable().frame(width: 24, height: 24)
                                    .padding(2)
                            }
                        }.padding([.top, .bottom], 10)
                    }
                    
                    if let num = repo.commitsCount {
                        Text("number of commits: \(num)")
                    }
                    
                    if firstCommitLoadInProgress {
                        HStack (spacing: 10){
                            Text("Loading first commit")
                            LoaderView()
                        }
                    }
                    
                    if let first = repo.firstCommit {
                        HStack {
                            Text("First commit date:").font(.system(size: 18, weight: .bold))
                            Text(first.detail.author.date)
                        }
                        
                    }
                    
                    if let safeDescription = repo.description {
                        Text("description: \n\(safeDescription)")
                    }
                    
                    
                    
                    if let _ = repo.firstCommit {
                        Text("First commit files:").font(.system(size: 18, weight: .bold)).padding(.bottom, 6)
                        RepoFilesView(repo: repo)
                    }
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    Task { await self.fetchFirstCommit(for: self.repo) }
                }
                .navigationTitle(repo.name)
            }
        }
        
    }
    
    // MARK: Private
    @State private var firstCommitLoadInProgress: Bool = false
    
    private func fetchFirstCommit(for repo: Repo) async {
        
        
        firstCommitLoadInProgress = true
        Task(priority: .background) {
//            print(repo)
            let result = await GithubService().loadFirstCommit(for: repo)
            switch result {
            case .success(let res):
//                print(res)
                self.repo.firstCommit = res[0]
                firstCommitLoadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                firstCommitLoadInProgress = false
            }
        }
        
        
    }
}
