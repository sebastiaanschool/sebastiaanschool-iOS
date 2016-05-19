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
        let testExpectation = expectationWithDescription("test")
        
        SebastiaanApiClient.sharedApiClient.fetchBulletins { (bulletinsResult) in
            testExpectation.fulfill()
            
            switch bulletinsResult {
            case .Success(let bulletins):
                XCTAssertEqual(bulletins.count, 2)
                print(bulletins)
            default:
                XCTFail("Something was wrong: \(bulletinsResult)")
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testFetchAgendaItems() {
        let testExpectation = expectationWithDescription("test")
        
        SebastiaanApiClient.sharedApiClient.fetchAgendaItems { (agendaItemsResult) in
            testExpectation.fulfill()
            
            switch agendaItemsResult {
            case .Success(let agendaItems):
                XCTAssertEqual(agendaItems.count, 2)
                print(agendaItems)
            default:
                XCTFail("Something was wrong: \(agendaItemsResult)")
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
