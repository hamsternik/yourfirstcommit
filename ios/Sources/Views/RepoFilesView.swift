//
//  RepoFilesView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI


struct RepoFilesView: View {
    
    @State var repo: Repo
    
    @EnvironmentObject var githubApi: GithubApiService
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            if githubApi.repoFilesLoading {
                LoaderView()
            } else {
                
                if let results = githubApi.repoFilesResults {
                    
                    List {
                        ForEach(results, id: \.self) { file in
                            Text(file.name).padding(0)
                            
                        }
                    }.listStyle(PlainListStyle())
                    
                    
                }
            }
            
            
            

        }.onAppear {
            self.githubApi.getRepoFiles(for_repo: self.repo)
        }
        
    }
    
}

//struct RepoFilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepoFilesView()
//    }
//}
