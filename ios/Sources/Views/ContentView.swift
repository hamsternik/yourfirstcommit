//
//  ContentView.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your First Commit")
                        .font(.title)
                        .padding(.bottom)
                    
                    // 1.. typing repo name
                    
                    RepoNameField()
                    
                    // 2.. getting files listing of initial commit
                    
                    // 3.. profit!
                    
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
        }
        .navigationTitle("Your First Commit")
    }
}
