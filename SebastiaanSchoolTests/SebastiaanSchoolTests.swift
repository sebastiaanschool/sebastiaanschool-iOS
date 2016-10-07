//
//  SebastiaanSchoolTests.swift
//  SebastiaanSchoolTests
//
//  Created by Jeroen Leenarts on 17-05-16.
//
//

import XCTest
@testable import SebastiaanSchool
//import JsonApiClient


class SebastiaanSchoolTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchBulletins() {
        let testExpectation = expectation(description: "test")
        
        SebastiaanApiClient.sharedApiClient.fetchBulletins { (bulletinsResult) in
            testExpectation.fulfill()
            
            switch bulletinsResult {
            case .success(let bulletins):
                XCTAssertEqual(bulletins.count, 3)
                print(bulletins)
            default:
                XCTFail("Something was wrong: \(bulletinsResult)")
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testFetchAgendaItems() {
        let testExpectation = expectation(description: "test")
        
        SebastiaanApiClient.sharedApiClient.fetchAgendaItems { (agendaItemsResult) in
            testExpectation.fulfill()
            
            switch agendaItemsResult {
            case .success(let agendaItems):
                XCTAssertEqual(agendaItems.count, 41)
                print(agendaItems)
            default:
                XCTFail("Something was wrong: \(agendaItemsResult)")
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testFetchContactItems() {
        let testExpectation = expectation(description: "test")
        
        SebastiaanApiClient.sharedApiClient.fetchContactItems { (contactItemsResult) in
            testExpectation.fulfill()
            
            switch contactItemsResult {
            case .success(let contactItems):
                XCTAssertEqual(contactItems.count, 13)
                print(contactItems)
            default:
                XCTFail("Something was wrong: \(contactItemsResult)")
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
