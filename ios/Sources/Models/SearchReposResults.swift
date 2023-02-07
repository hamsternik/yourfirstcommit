//
//  SearchReposResults.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

struct SearchReposResults: Codable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [Repo]
}
