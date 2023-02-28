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
    var files: RepoFilesTree?
    
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


// MARK: Mocked Data

extension CommitAuthor {
    struct Mocked {
        let author0 = CommitAuthor(name: "King Artur", email: "iamking@gmail.com", date: "01.01.2001")
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

extension CommitDetail {
    struct Mocked {
        let detail0 = CommitDetail(message: "Hello there", author: CommitAuthor.mocked.author0)
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

extension Commit {
    struct Mocked {
        let commit0 = Commit(url: "https://google.com", sha: "xxxzzzaaapppxxx", detail: CommitDetail.mocked.detail0, files: RepoFilesTree.mocked.tree0)
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}
