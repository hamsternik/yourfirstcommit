//
//  GithubApi.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation

class GithubApiService: ObservableObject {
    
    private let apiRootURL: String = "https://api.github.com/"
    
    @Published var searchRepoLoading: Bool = false
    @Published var repoFilesLoading: Bool = false
    
    
    @Published var searchRepoResults: SearchReposResults?
    
    @Published var repoFilesResults: [RepoFile]?
    
    
    func searchRepo(for_name: String){
        self.searchRepoLoading = true // to show loader spinner
        self.searchRepoResults = nil // to reset previous search on views
        
        if let url = URL(string: apiRootURL + "search/repositories?q=" + for_name) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        
                        //print("JSON String: \(String(data: safeData, encoding: .utf8))")
                        do {
                            let result = try decoder.decode(SearchReposResults.self, from: safeData)
                            DispatchQueue.main.async {
                                self.searchRepoResults = result
                                // cutting to 5 if more for simplicity
                                if result.items.count > 5 {
                                    self.searchRepoResults!.items = Array(result.items[0 ..< 5])
                                }
                                self.searchRepoLoading = false
                                
                            }
                        } catch {
                            print(error)
                            DispatchQueue.main.async {
                                self.searchRepoLoading = false
                            }
                        }
                        
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func getRepoFiles(for_repo: Repo){
        self.repoFilesLoading = true // to show loader spinner
        self.repoFilesResults = nil // to reset previous search on views
        
        if let url = URL(string: apiRootURL + "repos/" + for_repo.full_name + "/contents") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        
                        //print("JSON String: \(String(data: safeData, encoding: .utf8))")
                        do {
                            let result = try decoder.decode([RepoFile].self, from: safeData)
                            DispatchQueue.main.async {
                                self.repoFilesResults = result
                                // cutting to 5 if more for simplicity
                                if result.count > 100 {
                                    self.repoFilesResults = Array(result[0 ..< 100])
                                }
                                self.repoFilesLoading = false
                                
                            }
                        } catch {
                            print(error)
                            DispatchQueue.main.async {
                                self.repoFilesLoading = false
                            }
                        }
                        
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    
}
