//
//  RepoFilesView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

//protocol FilesLoaderViewDelegate: AnyObject {
//    func loadFiles(for repo: Repo, and commit: Commit) -> Bool
//}

struct RepoFilesView_Previews: PreviewProvider {
    static var previews: some View {
        RepoFilesView(repo: .mocked.repo1)
    }
}

struct RepoFilesView: View {

//    weak var delegate: FilesLoaderViewDelegate?
    var repo: Repo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if repoFileLoadInProgress {
                LoaderView()
            } else {
                List {
                    ForEach(repoFiles, id: \.self) { file in
                        Text(file.path).padding(0)
                            .font(.system(.body, design: .monospaced))
                            .background(Color.gray.opacity(0.25))
                    }
                }.listStyle(PlainListStyle())
            }
            
        }.onAppear {
            Task { await self.startRepoFirstFilesLoading(for: self.repo) }
        }
    }
    

    
    
    // MARK: Private
    
    @State private var repoFiles: [RepoFile] = []
    @State private var repoFileLoadInProgress: Bool = false
    
    
    private func startRepoFirstFilesLoading(for repo: Repo) async {
        repoFileLoadInProgress = true
        do {
            try await GithubApiService().loadFirstRepoFiles(for: repo) { (result, error) in
                if let files = result {
                    repoFiles = files
                    repoFileLoadInProgress = false
                } else if let _ = error {
                    //Handle or show this error somehow
                    repoFileLoadInProgress = false
                }
            }
        } catch {
            print("Request in startRepoFilesLoading failed with error: \(error)")
        }
    }
    
    
    private func startRepoLatestFilesLoading(for repo: Repo) async {
        repoFileLoadInProgress = true
        do {
            try await GithubApiService().loadLatestRepoFiles(for: repo) { (result, error) in
                if let files = result {
                    repoFiles = files
                    repoFileLoadInProgress = false
                } else if let _ = error {
                    //Handle or show this error somehow
                    repoFileLoadInProgress = false
                }
            }
        } catch {
            print("Request in startRepoFilesLoading failed with error: \(error)")
        }
    }
    
}
