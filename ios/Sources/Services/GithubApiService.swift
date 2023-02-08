//
//  GithubApi.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation


enum RequestError: Error {
    
    // TODO: move this enum somewhere
    
    case decode
    case invalidURL
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        default:
            return "Unknown error"
        }
    }
}



struct GithubApiService {
    func newSearchGithub(forRepo repoName: String, completion: @escaping(SearchReposResults?, Error?) -> Void) async throws {
        
        guard let url = URL(string: baseURL + "search/repositories?q=" + repoName) else {
            throw RequestError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            var result = try JSONDecoder().decode(SearchReposResults.self, from: data)
            
            if result.items.count > 20 {
                result.items = Array(result.items[0 ..< 20])
            }
            
            completion(result, nil)
        } catch (let decodingError) {
            
            // TODO: Better completion or throw here?
            
            completion(nil, decodingError)
            //throw RequestError.decode
        }
    }
    
    func loadRepoFiles(for repo: Repo, completion: @escaping([RepoFile]?, Error?) -> Void) async throws {
        
        guard let url = URL(string: baseURL + "repos/" + repo.fullName + "/contents") else {
            throw RequestError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            var result = try JSONDecoder().decode([RepoFile].self, from: data)
            
            if result.count > 256 {
                result = Array(result[0 ..< 256])
            }
            
            completion(result, nil)
        } catch (let decodingError) {
            
            // TODO: Better completion or throw here?
            
            completion(nil, decodingError)
            //throw RequestError.decode
        }
        
    }
    
    // TODO: refactor to collapse two similiar methods into single
    
    private let baseURL: String = "https://api.github.com/"
}
