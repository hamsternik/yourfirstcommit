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
    case unexpectedHeaders
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        case .unexpectedHeaders:
            return "Unexpected Headers"
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
    
    func loadFirstRepoFiles(for repo: Repo, completion: @escaping([RepoFile]?, Error?) -> Void) async throws {
        
        guard let firstCommit = repo.firstCommit else {
            throw RequestError.unknown
        }
        
        guard let url = URL(string: baseURL + "repos/" + repo.fullName + "/git/trees/" + firstCommit.sha + "?recursive=0") else {
            throw RequestError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            var result = try JSONDecoder().decode(RepoFilesTree.self, from: data)
            
            if result.tree.count > 256 {
                result.tree = Array(result.tree[0 ..< 256])
            }
            
            completion(result.tree, nil)
        } catch (let decodingError) {
            
            // TODO: Better completion or throw here?
            
            completion(nil, decodingError)
            //throw RequestError.decode
        }
        
    }
    
    func loadLatestRepoFiles(for repo: Repo, completion: @escaping([RepoFile]?, Error?) -> Void) async throws {
        
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
    
    func loadFirstCommit(for repo: Repo, completion: @escaping(Commit?, Error?) -> Void) async throws {
        
        guard let numCommits: Int? = try await self.getNumberOfCommits(for: repo) else {
            throw RequestError.unknown
            
        }
        
        guard let url = URL(string: baseURL + "repos/" + repo.fullName + "/commits?per_page=1&page=" + String(numCommits!) ) else {
            throw RequestError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            var result = try JSONDecoder().decode([Commit].self, from: data)
//            print(result)
            
            completion(result[0], nil)
        } catch (let decodingError) {
            
            // TODO: Better completion or throw here?
            
            completion(nil, decodingError)
            //throw RequestError.decode
        }
        
    }
    
    // TODO: refactor to collapse three similiar methods into single
    
    
    private func getNumberOfCommits(for repo: Repo) async throws -> Int {
        
        // Tricky approach to get total number of commits in repository from HTTP headers
        // Found here as a CURL-request: https://gist.github.com/0penBrain/7be59a48aba778c955d992aa69e524c5
        // Remaked for Swift.
        // Changed minimum iOS deployment target to 16.0 for make possible using Swift regex here
        
        guard let url = URL(string: baseURL + "repos/" + repo.fullName + "/commits?per_page=1") else {
            throw RequestError.invalidURL
        }

        let (_, response) = try await URLSession.shared.bytes(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw RequestError.unknown
        }
        
        let httpResponse = response as! HTTPURLResponse // TODO: Is force-casting here okay?

        
        if let linksRawHeaderString = httpResponse.allHeaderFields["Link"] {

            let links = (linksRawHeaderString as! String).components(separatedBy: ",")

            var dictionary: [String: String] = [:]
            links.forEach({
                let components = $0.components(separatedBy:"; ")
                let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                dictionary[components[1]] = cleanPath
            })

            // if let nextPagePath = dictionary["rel=\"next\""] { print("nextPagePath: \(nextPagePath)") }

            // decouple "last" item in link header
            if let lastPagePath = dictionary["rel=\"last\""] {
               
                let lastDigitInStringRegex = /\d+$/
                
                if let result = lastPagePath.firstMatch(of: lastDigitInStringRegex) {
                    if let count = Int(result.0) {
                        return count
                    }
                }
            }
        }
        
        throw RequestError.unexpectedHeaders
        
    }
    
    private let baseURL: String = "https://api.github.com/"
}
