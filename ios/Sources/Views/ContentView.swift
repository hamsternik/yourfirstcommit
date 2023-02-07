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
            contentView
                .padding()
                .navigationTitle("Your First Commit")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            centeredContentView
            // 1.. typing repo name
            RepoNameField()
            // 2.. getting files listing of initial commit
            // 3.. profit!
        }
    }
    
    private var centeredContentView: some View {
        VStack {
            Spacer()
            Text("""
            Onboarding text here.
            Let's tell our users what the app is about.
            Need to figure out what the impressive copy should be there.
            Maybe we need to add a simple instruction / steps to follow user how the app works.
            """)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
