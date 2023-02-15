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
    var htmlUrl: String
    var description: String? // not all repos have a description
    var commitsCount: Int?
    var firstCommit: Commit?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case id
        case name
    }
}

// MARK: Mocked Data

extension Repo {
    struct Mocked {
        let repo1 = Repo(id: 1, name: "firstRepo", fullName: "First Repo", htmlUrl: "https://agithub.com/repo1")
        let repo2 = Repo(id: 2, name: "secondRepo", fullName: "Second Repo", htmlUrl: "https://agithub.com/repo2")
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}
