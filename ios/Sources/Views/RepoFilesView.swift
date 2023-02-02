//
//  RepoFilesView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI


struct RepoFilesView: View {
    
    @State var repo: Repo
    
    @State private var repoFiles:[RepoFile] = []
    @State private var repoFileLoadInProgress: Bool = false
    
    private func startRepoFilesLoading(for repo: Repo) {
        repoFileLoadInProgress = true
        GithubApiService().loadRepoFiles(for: repo) { (result, error) in
            if let files = result {
                repoFiles = files
                repoFileLoadInProgress = false
            } else if let _ = error {
                //Handle or show this error somehow
                repoFileLoadInProgress = false
            }
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            if repoFileLoadInProgress {
                LoaderView()
            } else {
                
                List {
                    ForEach(repoFiles, id: \.self) { file in
                        Text(file.name).padding(0)
                            .font(.system(.body, design: .monospaced))
                            .background(Color.gray.opacity(0.25))
                    }
                }.listStyle(PlainListStyle())
            }
            
        }.onAppear {
            self.startRepoFilesLoading(for: self.repo)
        }
    }
}

//struct RepoFilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepoFilesView()
//    }
//}
