//
//  RepoFilesView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct RepoFilesView_Previews: PreviewProvider {
    static var previews: some View {
        RepoFilesView(repo: .mocked.repo1)
    }
}

struct RepoFilesView: View {
    @State var repo: Repo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if repoFileLoadInProgress {
                LoaderView()
            } else {
                
                if let files = repo.firstCommit?.files?.tree {
//                    List {
                        ForEach(files, id: \.self) { file in
                            Text(file.path).padding(0)
                                .font(.system(.body, design: .monospaced))
                                .background(Color.gray.opacity(0.25))
                                .padding(0)
                        }
//                    }
//                    .listStyle(PlainListStyle())
                    
                } else {
                    Text("No files :(")
                }
                
            }
            
        }.onAppear {
            self.startRepoFilesLoading(for: self.repo)
        }
    }
    
    // MARK: Private
    
//    @State private var repoFiles: [RepoFile] = []
    @State private var repoFileLoadInProgress: Bool = false
    
    
    
    private func startRepoFilesLoading(for repo: Repo) {
        
        repoFileLoadInProgress = true
        Task(priority: .background) {
            let result = await GithubService().loadFirstCommitFiles(for: repo)
            switch result {
            case .success(let res):
//                repoFiles = res.tree
                self.repo.firstCommit?.files = res
                repoFileLoadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                repoFileLoadInProgress = false
            }
        }
    }
}
