//
//  RepoView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView(repo: .mocked.repo1)
    }
}

struct RepoView: View  {
    
    @State var repo: Repo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.title)
            Text(repo.fullName)
            
            Text("id: \(repo.id)")
            
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
                Text("First commit date: \(first.detail.author.date)")
            }
            
            if let safeDescription = repo.description {
                Text("description: \n\(safeDescription)")
            }
            
            if let repoURL = URL(string: repo.htmlUrl) {
                Link(destination: repoURL) {
                    HStack {
                        Text("Open in browser")
                        Image(systemName: "link.circle.fill").font(.title)
                    }
                    
                }
            }
            
            if let _ = repo.firstCommit {
                Text("First commit files:")
                RepoFilesView(repo: repo)
            }

            
            
        }
        .padding()
        .onAppear {
            Task { await self.fetchFirstCommit(for: self.repo) }
        }
    }
    
    
    // MARK: Private
    @State private var firstCommitLoadInProgress: Bool = false
    
    private func fetchFirstCommit(for repo: Repo) async {
        
        
        firstCommitLoadInProgress = true
        Task(priority: .background) {
            let result = await GithubService().loadFirstCommit(for: repo)
            switch result {
            case .success(let res):
                self.repo.firstCommit = res[0]
                firstCommitLoadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                firstCommitLoadInProgress = false
            }
        }

    
    }
    
}
