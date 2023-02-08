//
//  GithubApi.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

struct GithubApiService {
    func newSearchGithub(forRepo repoName: String, completion: @escaping(SearchReposResults?, Error?) -> Void) {
        if let url = URL(string: baseURL + "search/repositories?q=" + repoName) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                
                if let error = error {
                    print("error is \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    // THERE IS NO DATA RETURNED, Might want to handle this case
                    print("no data returned?")
                    return
                }
                
                do {
                    var result = try JSONDecoder().decode(SearchReposResults.self, from: data)
                    
                    if result.items.count > 20 {
                        result.items = Array(result.items[0 ..< 20])
                    }
                    
                    
                    
                    completion(result, nil)
                } catch (let decodingError) {
                    print(decodingError)
                    
                    completion(nil, decodingError)
                }
                
            }
            task.resume()
        }
    }
    
    func loadRepoFiles(for repo: Repo, completion: @escaping([RepoFile]?, Error?) -> Void) {
        if let url = URL(string: baseURL + "repos/" + repo.fullName + "/contents") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("error is \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    // THERE IS NO DATA RETURNED, Might want to handle this case
                    return
                }
                
                do {
                    var result = try JSONDecoder().decode([RepoFile].self, from: data)
                    
                    if result.count > 256 {
                        result = Array(result[0 ..< 256])
                    }
                    
                    completion(result, nil)
                } catch (let decodingError) {
                    completion(nil, decodingError)
                }
                
            }
            task.resume()
        }
    }
    
    private let baseURL: String = "https://api.github.com/"
}
