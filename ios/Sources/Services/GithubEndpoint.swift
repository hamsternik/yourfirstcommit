//
//  GithubEndpoints.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

enum GithubEndpoint {
    case searchRepositories(repoName: String)
    case commitFiles(repoName: String, commitSha: String)
    case firstCommit(repoName: String, numCommits: Int)
    case numberOfCommits(repoName: String)
}

extension GithubEndpoint: Endpoint {
    
   
    var urlComponents: URLComponents? {
        switch self {
        case .searchRepositories(let repoName):
            return URLComponents(string: "\(self.host)/search/repositories?q=\(repoName)")
        
        case .commitFiles(let repoName, let commitSha):
            return URLComponents(string: "\(self.host)/repos/\(repoName)/git/trees/\(commitSha)?recursive=0")
        
        case .firstCommit(let repoName, let numCommits):
            return URLComponents(string: "\(self.host)/repos/\(repoName)/commits?per_page=1&page=\(numCommits)")
            
        case .numberOfCommits(let repoName):
            return URLComponents(string: "\(self.host)/repos/\(repoName)/commits?per_page=1")
        }
    }
    
    var host: String {
        return "https://api.github.com"
    }
    

    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
//        let accessToken = "insert your access token here -> https://www.themoviedb.org/settings/api"
        switch self {
        default:
            return nil
//            return [
//                "Authorization": "Bearer \(accessToken)",
//                "Content-Type": "application/json;charset=utf-8"
//            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}


