//
//  NetworkTests.swift
//  YourFirstCommitTests
//
//  Created by Alex Antipov on 08.02.2023.
//

import XCTest
@testable import YourFirstCommit

final class NetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirstCommitLoading() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let repo: Repo = Repo(id: 1, name: "pomodoress", fullName: "r-ss/pomodoress", htmlUrl: "h-ti-ti")
        
        
        Task(priority: .background) {
            let result = await GithubService().loadFirstCommit(for: repo)
            switch result {
            case .success(let res):
                XCTAssertEqual(res[0].detail.message, "initial")
                XCTAssertEqual(res[0].detail.author.name, "Alex Antipov")
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
            }
        }
        
                
    }


}
