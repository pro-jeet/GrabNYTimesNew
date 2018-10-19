//
//  NetworkManagerTests.swift
//  GrabNYTimesTests
//
//  Created by Jitesh Sharma on 19/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager?
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.sharedInstance
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testSendUrlRequestToServer() {
        
        let requestString = String(format:baseURL,NY_API_Key)
        networkManager?.sendUrlRequestToServer(url: requestString, parameters: nil, taskType: 1, complitionHandler: { (response,status) in
            
            XCTAssertTrue(status)
            if(status)
            {
                print("Success")
                XCTAssertNotNil(response)
            }
            
        })
    }
    
    func testPerformanceSendUrlRequestToServer() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
