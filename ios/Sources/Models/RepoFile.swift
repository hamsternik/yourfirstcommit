//
//  RepoContent.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

/// Represent a files in repository
/// API URL example: https://api.github.com/repos/aristocratos/btop/contents
struct RepoFile: Codable, Hashable {
    var name: String
    var path: String
    var type: String // "dir" or "file"
}
