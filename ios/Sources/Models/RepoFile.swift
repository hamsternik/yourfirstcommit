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
    var type: String
    var size: Int?
}
