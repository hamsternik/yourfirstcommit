//
//  RepoView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI


struct RepoView: View {
    
    @State var repo: Repo
    
    @EnvironmentObject var githubApi: GithubApiService
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 6) {
                Text(repo.name).font(.title)
                Text(repo.full_name)
                
                Text("id: \(repo.id)")
                
                if let safeDescription = repo.description {
                    Text("description: \n\(safeDescription)")
                }
                
                
                //            Text("link: \n\(repo.html_url)")
                
                Link(destination: URL(string: repo.html_url)!) {
                    HStack {
                        Text("Open in browser")
                        Image(systemName: "link.circle.fill").font(.title)
                    }
                    
                }
                
                Text("Files in repo (latest):")
                RepoFilesView(repo: self.repo)
                
                
                
            }
        }
    }
}

struct RepoView_Previews: PreviewProvider {
    
    @State static var repo = Repo(id: 666, name: "PreviewRepo", full_name: "ress/previewrepo", html_url: "https://repo.com")
    @State static var githubApiService = GithubApiService()
    
    static var previews: some View {
        RepoView(repo: repo).environmentObject(githubApiService)
    }
}
