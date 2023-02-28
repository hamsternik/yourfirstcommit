//
//  Repo.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

struct Repo: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var fullName: String
    var language: String?
    var starsNumber: Int
    var forksNumber: Int
    var htmlUrl: String
    var description: String? // not all repos have a description
    var commitsCount: Int?
    var firstCommit: Commit?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case language
        case starsNumber = "stargazers_count"
        case forksNumber = "forks_count"
    }
}

// MARK: Mocked Data

extension Repo {
    struct Mocked {
        
        let repo1 = Repo(id: 1, name: "firstRepo", fullName: "First Repo", language:"C++", starsNumber:6, forksNumber:2, htmlUrl: "https://agithub.com/repo1", commitsCount: 66, firstCommit: Commit.mocked.commit0)
        let repo2 = Repo(id: 2, name: "secondRepo", fullName: "Second Repo", language:"C++", starsNumber:6, forksNumber:2, htmlUrl: "https://agithub.com/repo2")
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}
