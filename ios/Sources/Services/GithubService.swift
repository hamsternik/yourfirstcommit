//
//  GithubApi.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 24.01.2023.
//

import Foundation


protocol GithubServiceable {
    func searchRepositories(name: String) async -> Result<SearchReposResults, RequestError>
    //    func loadFirstCommit(for repo: Repo) async -> Result<[Commit], RequestError>
    func loadFirstCommitFiles(for repo: Repo) async -> Result<RepoFilesTree, RequestError>
}


struct GithubService: HTTPClient, GithubServiceable {
    
    func searchRepositories(name: String) async -> Result<SearchReposResults, RequestError> {
        return await sendRequest(endpoint: GithubEndpoint.searchRepositories(repoName: name), responseModel: SearchReposResults.self)
    }
    
    func loadFirstCommit(for repo: Repo) async -> Result<(commits: Int, first: Commit), RequestError> {
        
        // Getting number of commint to make first of them
       
        let numCommitsRequestResult:Result<Int, RequestError> = await self.getNumberOfCommits(for: repo)
        
        
        switch numCommitsRequestResult {
        case .success(let numCommits):
            
            let firstCommitRequestResult:Result<[Commit], RequestError> = await sendRequest(endpoint: GithubEndpoint.firstCommit(repoName: repo.fullName, numCommits: numCommits), responseModel: [Commit].self)
            
            switch firstCommitRequestResult {
            case .success(let result):
                return Result.success((commits: numCommits, first: result.first!))
                
            case .failure(let error):
                return .failure(error)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loadFirstCommitFiles(for repo: Repo) async -> Result<RepoFilesTree, RequestError> {
        guard let firstCommit = repo.firstCommit else {
            return Result.failure(RequestError.before)
        }
        return await sendRequest(endpoint: GithubEndpoint.commitFiles(repoName: repo.fullName, commitSha: firstCommit.sha), responseModel: RepoFilesTree.self)
    }
    
    private func getNumberOfCommits(for repo: Repo) async -> Result<Int, RequestError> {
        
        // Tricky approach to get total number of commits in repository from HTTP headers
        // Found here as a CURL-request: https://gist.github.com/0penBrain/7be59a48aba778c955d992aa69e524c5
        // Remaked for Swift.
        // Changed minimum iOS deployment target to 16.0 for make possible using Swift regex here
        
        guard let url = URL(string: "https://api.github.com/repos/" + repo.fullName + "/commits?per_page=1") else {
            return .failure(.invalidURL)
        }
        
        guard let (_, response) = try? await URLSession.shared.bytes(from: url) else {
            return .failure(.custom(message: "Error getting bytes for URLSession"))
        }
        
        
        let resp = response as! HTTPURLResponse
        
        guard let apiRateLimitRemaining = try? Int( resp.allHeaderFields["x-ratelimit-remaining"] as! String ) else {
            return .failure(.custom(message: "Error in do/catch inside getNumberOfCommits()"))
        }
        
        
        print("API rate limit remaining:", apiRateLimitRemaining)
        if apiRateLimitRemaining == 0 {
            return .failure(.custom(message: "GitHub API requests rate limit reached. Wait a bit or implement auth :)"))
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return .failure(.unexpectedStatusCode)
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
                        //print("Number of commits:", count)
                        return .success(count)
                    }
                }
            }
        }
        
        return .failure(.unexpectedHeaders)
    }
    
    
}
