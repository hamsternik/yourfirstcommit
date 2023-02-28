//
//  RepoContent.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

/// Represent a files in repository
/// API URL example: https://api.github.com/repos/r-ss/flight-search/git/trees/6ee015f5adb9a49765483cb58eb56b2552656c50?recursive=0

struct RepoFilesTree: Codable, Hashable {
    var tree: [RepoFile]
}

struct RepoFile: Codable, Hashable {
    var path: String
    var type: String // blob or tree
    var size: Int?
}

// MARK: Mocked Data

extension RepoFile {
    struct Mocked {
        let file0 = RepoFile(path: "setup-examples", type: "tree", size: 13618)
        let file1 = RepoFile(path: ".gitignore", type: "blob", size: 255)
        let file2 = RepoFile(path: "README.md", type: "blob", size: 620)
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

extension RepoFilesTree {
    struct Mocked {
        let tree0 = RepoFilesTree(tree: [RepoFile.mocked.file0, RepoFile.mocked.file1, RepoFile.mocked.file2])
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}
