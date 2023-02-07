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

struct RepoView: View {
    
    @State var repo: Repo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.title)
            Text(repo.fullName)
            
            Text("id: \(repo.id)")
            
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
            
            Text("Files in repo (latest):")
            RepoFilesView(repo: repo)
        }
        .padding()
    }
}
