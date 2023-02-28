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

// User Flow
// (1) typing repo name
// (2) getting files listing of initial commit
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                contentView
                    .padding()
                    .navigationTitle("Your First Commit")
                    .navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
    
    // MARK: Private
    
    @State private var repoName: String = ""
    @State private var isActive = false
    @State private var reposSearchInProgress: Bool = false
    @State private var foundRepos: SearchReposResults? = nil
    @State private var secondaryIsPressed = false
    
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            SearchFieldView(searchString: $repoName) { searchString in
                if searchString == "" {
                    // Handle cross tap in searchFiend, resetting results and whole screen to initial state
                    foundRepos = nil
                    return
                }
                startGithubSearch(for: searchString)
            }
            
            Group {
                if let repos = foundRepos?.items {
                    List {
                        ForEach(repos, id: \.self) { repo in
                            NavigationLink {
                                RepoView(repo: repo)
                            } label: {
                                Text(repo.fullName).padding(0)
                            }.listRowSeparator(.hidden).padding(0)
                        }
                    }.listStyle(PlainListStyle())
                } else {
                    
                    if !reposSearchInProgress {
                        

                        centeredContentView

                        
                    } else {
                        centeredLoadingView
                    }
                    
                    footerView
                        .padding(.bottom)
                    
                }
            }
            
//            Group {
//                if !reposSearchInProgress {
//                    centeredContentView
//                } else {
//                    centeredLoadingView
//                }
//            }
//
            
            
        }
        
        NavigationLink(
            destination: GitHubSearchResults(results: self.foundRepos),
            isActive: $isActive
        ) { EmptyView() }
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
                .padding(.bottom)
            Spacer()
        }
    }
    
    private var centeredLoadingView: some View {
        VStack {
            Spacer()
            LoaderView()
            Spacer()
        }
    }
    
    private var footerView: some View {
        VStack {
            Text("Try it out with the simplified way to look up a random repo 👇")
                .padding(.bottom, 8)
            secondaryButton {
                let randomRepoName = predefinedRepos.randomElement() ?? ""
                print(">> randomRepoName \(randomRepoName)")
                repoName = randomRepoName
                startGithubSearch(for: randomRepoName)
            }.buttonStyle(HighlightedButtonStyle())
        }
    }
    
    @ViewBuilder
    private func secondaryButton(perform action: @escaping () -> Void) -> some View {
        let margin: CGFloat = 16
        let imageSize: CGSize = .init(width: 16, height: 16)
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: imageSize.height / 2)
                    .fill(Color.randomRepoImageBackground)
                    .frame(width: imageSize.width * 2, height: imageSize.height * 2)
                Image(systemName: "book.closed")
                    .frame(width: imageSize.width, height: imageSize.height, alignment: .center)
            }
            .frame(width: 40, height: 40, alignment: .center)
            .padding(.leading, margin)
            Text("Look Up Random Repo")
            Spacer()
            Image(systemName: "arrow.right.square")
                .frame(width: imageSize.width, height: imageSize.height, alignment: .center)
                .padding(.trailing, margin)
        }
        .frame(height: 60)
        .background(background)
        .opacity(secondaryIsPressed ? 0.75 : 1.0)
        .onTapGesture {
            action()
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged { _ in self.secondaryIsPressed = true }
                .onEnded { _ in self.secondaryIsPressed = false }
        )
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.randomRepoBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.randomRepoBackground, lineWidth: 1)
            )
    }
    
    // Some repos fo quick switching
    // by "I'm Feeling Lucky" button
    private let predefinedRepos: [String] = [
        "tensorflow",
        "btop",
        "ahawker/ulid",
        "nomnoml",
        "IKEv2-setup",
        "powerlevel10k",
        "spectre.css"
    ]
    
    private func startGithubSearch(for name: String) {
        
        reposSearchInProgress = true
        Task(priority: .background) {
            let result = await GithubService().searchRepositories(name: name)
            switch result {
            case .success(let repos):
                foundRepos = repos
                reposSearchInProgress = false
                //isActive = true
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                reposSearchInProgress = false
            }
        }
        
    
    }
}

struct HighlightedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.isPressed
        ? configuration.label.opacity(0.8)
        : configuration.label.opacity(1)
    }
}

private extension Color {
    static var randomRepoBackground: Color {
        .init("random-repo.background")
    }
    
    static var randomRepoImageBackground: Color {
        .init("random-repo.image.background")
    }
    
}
