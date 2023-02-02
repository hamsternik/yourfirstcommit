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
    var full_name: String
    var html_url: String
    var description: String? // not all repos have a description
}
