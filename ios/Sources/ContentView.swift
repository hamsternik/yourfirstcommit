//
//  ContentView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var githubApi = GithubApiService()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Your First Commit").font(.title).padding(.bottom)
                
                // 1.. typing repo name
                
                
                
                RepoNameField()
                
                // 2.. getting files listing of initial commit
                
                //FileList()
                
                // 3.. profit!
                
                
            }
            .padding()
            .frame(width: geometry.size.width, alignment: .leading)
            .environmentObject(githubApi)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
