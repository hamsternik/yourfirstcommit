//
//  GithubApi.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation


protocol GithubServiceable {
    func searchRepositories(name: String) async -> Result<SearchReposResults, RequestError>
    func loadFirstCommit(for repo: Repo) async -> Result<[Commit], RequestError>
    func loadFirstCommitFiles(for repo: Repo) async -> Result<RepoFilesTree, RequestError>
}


struct GithubService: HTTPClient, GithubServiceable {
    
    func searchRepositories(name: String) async -> Result<SearchReposResults, RequestError> {
        return await sendRequest(endpoint: GithubEndpoint.searchRepositories(repoName: name), responseModel: SearchReposResults.self)
    }
    
    func loadFirstCommit(for repo: Repo) async -> Result<[Commit], RequestError> {
        var numCommits: Int?
        do {
            numCommits = try await self.getNumberOfCommits(for: repo)
        } catch (let _) {
            return Result.failure(RequestError.unknown)
        }
        
        if let num = numCommits {
            return await sendRequest(endpoint: GithubEndpoint.firstCommit(repoName: repo.fullName, numCommits: num), responseModel: [Commit].self)
        }
        return Result.failure(RequestError.unknown)
    }
    
    func loadFirstCommitFiles(for repo: Repo) async -> Result<RepoFilesTree, RequestError> {
        guard let firstCommit = repo.firstCommit else {
            return Result.failure(RequestError.before)
        }
        return await sendRequest(endpoint: GithubEndpoint.commitFiles(repoName: repo.fullName, commitSha: firstCommit.sha), responseModel: RepoFilesTree.self)
    }
    
    private func getNumberOfCommits(for repo: Repo) async throws -> Int {
        
        // Tricky approach to get total number of commits in repository from HTTP headers
        // Found here as a CURL-request: https://gist.github.com/0penBrain/7be59a48aba778c955d992aa69e524c5
        // Remaked for Swift.
        // Changed minimum iOS deployment target to 16.0 for make possible using Swift regex here
        
        guard let url = URL(string: "https://api.github.com/repos/" + repo.fullName + "/commits?per_page=1") else {
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
    
    
}
