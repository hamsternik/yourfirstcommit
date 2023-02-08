//
//  Commit.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 08.02.2023.
//

import Foundation

// api URL examples:
// https://api.github.com/repos/ahawker/ulid/commits/51f69c6abf0b31dfaa62fa80eec2ccae32e721ee
// https://api.github.com/repos/ahawker/ulid/git/commits/51f69c6abf0b31dfaa62fa80eec2ccae32e721ee
//                                           ^^^ this makes JSON output more compact

struct Commit: Codable, Hashable {
    var url: String
    var sha: String
    var detail: CommitDetail
    
    enum CodingKeys: String, CodingKey {
        case url
        case sha
        case detail = "commit"
    }
}

struct CommitDetail: Codable, Hashable {
    var message: String
    var author: CommitAuthor
}

struct CommitAuthor: Codable, Hashable {
    var name: String
    var email: String
    var date: String // TODO: Parse as a Date, not String
}
