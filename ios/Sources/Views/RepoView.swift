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
                    Text(repo.fullName)
                    if let repoURL = URL(string: repo.htmlUrl) {
                        Link(destination: repoURL) {
                            HStack {
                                Text("Open in browser")
                                Image(systemName: "link.circle.fill").font(.system(size: 24, weight: .bold)).padding(.trailing, 5)
                            }
                        }.padding([.top, .bottom], 10)
                    }
                    HStack(spacing: 0) {
                        
                        if let commits = repo.commitsCount {
                            Text("\(commits) commits").padding(.trailing, 10)
                        }
                        
                        if let stars = repo.starsNumber {
                            Image(systemName: "star.fill").font(.system(size: 16, weight: .medium)).padding(.trailing, 5)
                            Text("\(stars) stars").padding(.trailing, 10)
                        }
                        
                        if let forks = repo.forksNumber {
                            Image(systemName: "doc.on.doc").font(.system(size: 16, weight: .medium)).padding(.trailing, 5)
                            Text("\(forks) forks")
                        }
                        
                    }.padding(.bottom, 10)
                    
                    if firstCommitLoadInProgress {
                        HStack (spacing: 10){
                            Text("Loading first commit")
                            LoaderView()
                        }
                    }
                    
                    if let first = repo.firstCommit {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Color.gray.opacity(0.25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9).stroke(Color.gray.opacity(0.55), lineWidth: 1)
                                )
                                .frame(height: 40)
                            HStack {
                                Text("First commit:").font(.system(size: 18, weight: .bold))
                                Text(first.detail.author.date)
                            }
                        }
                    }
                    
                    if let safeDescription = repo.description {
                        Text("description: \n\(safeDescription)")
                    }
                    
                    if let _ = repo.firstCommit {
                        Text("First commit files:").font(.system(size: 18, weight: .bold)).padding([.top, .bottom], 6)
                        RepoFilesView(repo: repo)
                    }
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    Task { await self.fetchFirstCommit(for: self.repo) }
                }
                .navigationTitle(repo.name)
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
        
    }
    
    // MARK: Private
    private let iconSize: CGFloat = 20
    
    @State private var showAlert = false
    @State private var alertMessage: String = "Error..."
    
    @State private var firstCommitLoadInProgress: Bool = false
    
    private func makeAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func fetchFirstCommit(for repo: Repo) async {
        
        firstCommitLoadInProgress = true
        Task(priority: .background) {
            let requestResult: Result<(commits: Int, first: Commit), RequestError> = await GithubService().loadFirstCommit(for: repo)
            switch requestResult {
            case .success(let result):
//                print(result.commits)
//                print(result.first)
                
                self.repo.commitsCount = result.commits
                self.repo.firstCommit = result.first
                
                firstCommitLoadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                firstCommitLoadInProgress = false
                makeAlert(message: error.customMessage)
            }
        }
    }
}
