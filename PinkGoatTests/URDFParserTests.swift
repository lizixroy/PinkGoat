//
//  URDFParserTests.swift
//  PinkGoatTests
//
//  Created by Roy Li on 3/21/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import XCTest
import SWXMLHash
import SceneKit
@testable import PinkGoat

class URDFParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseJoint() {
        let parser = URDFParser()
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "joint-example", withExtension: "urdf") else {
            print("can't find file")
            return
        }
        guard let xmlData = try? Data(contentsOf: url) else {
            print("can't load xmlData")
            return
        }
        let indexer = SWXMLHash.parse(xmlData)
        print("joint 0: \(indexer["root"]["joint"][0])")
        print("joint 1: \(indexer["root"]["joint"][1])")
        
        let _joint = try! parser.parseJoint(jointIndexer: indexer["root"]["joint"][0])
        guard let joint = _joint else {
            XCTFail("joint shouldn't be nil")
            return
        }
        XCTAssertTrue(joint.name == "hip")
        XCTAssertTrue(joint.type == .continuous)
        XCTAssertTrue(joint.parentLinkName == "base_link")
        XCTAssertTrue(joint.childLinkName == "torso")
        XCTAssertTrue(joint.origin.xyz.x == 0.0)
        XCTAssertTrue(joint.origin.xyz.y == 0.0)
        XCTAssertTrue(fabs(joint.origin.xyz.z - 0.05) < 0.000001)
        XCTAssertTrue(joint.origin.rpy.x == 0.0)
        XCTAssertTrue(joint.origin.rpy.y == 0.0)
        XCTAssertTrue(joint.origin.rpy.z == 0.0)
    }
    
    func loadURDF(fileName: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let url = testBundle.url(forResource: fileName, withExtension: "urdf") else {
            print("can't find file")
            return nil
        }
        guard let xmlData = try? Data(contentsOf: url) else {
            print("can't load xmlData")
            return nil
        }
        return xmlData
    }
    
    func testParseLink() {
        guard let linkURDFData = loadURDF(fileName: "linkExample") else {
            XCTFail("Couldn't load link urdf")
            return
        }
        let indexer = SWXMLHash.parse(linkURDFData)
        let parser = URDFParser()
        guard let _link = try? parser.parseLink(indexer: indexer) else {
            XCTFail("parseLink shouldn't throw exception")
            return
        }
        guard let link = _link else {
            XCTFail("link should not be nil")
            return
        }
        let sceneNode = link.sceneNode
        let visualNode = link.visualNode
        XCTAssertNotNil(sceneNode, "sceneNode should not be nil")
        XCTAssertNotNil(visualNode, "visualNode should not be nil")
    }
}
