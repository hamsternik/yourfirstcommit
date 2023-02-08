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
        
        do  {
            
            try await GithubApiService().loadFirstCommit(for: repo) { (result, error) in
                if let first = result {
                    self.repo.firstCommit = first
                    firstCommitLoadInProgress = false
                    
                    
                    
                } else if let _ = error {
                    //Handle or show this error somehow
                    firstCommitLoadInProgress = false
                }
            }

        } catch {
            // TODO: is there any analog of do/catch/finally to not repeat firstCommitLoadInProgress = false
            firstCommitLoadInProgress = true
            
            print("Request in repoCommitLoadInProgress failed with error: \(error)")
        }
        
    
    }
    
}
