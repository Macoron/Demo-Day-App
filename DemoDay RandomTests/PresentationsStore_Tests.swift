//
//  DemoDay_RandomTests.swift
//  DemoDay RandomTests
//
//  Created by labsallday labsallday on 07.04.2021.
//

@testable import DemoDay_Random
import XCTest

class PresentationsStore_Tests: XCTestCase {

    func testSerialization() throws {
        
        let projects = testProjects
        let store = PresentationsStore(presentations: projects)
        
        store.saveData()
        store.loadData()
        
        XCTAssertEqual(projects, store.presentations)
    }


}
