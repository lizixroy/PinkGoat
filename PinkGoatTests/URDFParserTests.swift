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
        guard let origin = joint.origin else {
            XCTFail("origin shouldn't be nil")
            return
        }
        XCTAssertTrue(joint.name == "hip")
        XCTAssertTrue(joint.type == .continuous)
        XCTAssertTrue(joint.parentLinkName == "base_link")
        XCTAssertTrue(joint.childLinkName == "torso")
        XCTAssertTrue(origin.xyz.x == 0.0)
        XCTAssertTrue(origin.xyz.y == 0.0)
        XCTAssertTrue(fabs(origin.xyz.z - 0.05) < 0.000001)
        XCTAssertTrue(origin.rpy.x == 0.0)
        XCTAssertTrue(origin.rpy.y == 0.0)
        XCTAssertTrue(origin.rpy.z == 0.0)
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
        
        do {
            let _link = try parser.parseLink(indexer: indexer["link"])
            guard let link = _link else {
                XCTFail("link should not be nil")
                return
            }
            guard let sceneNode = link.sceneNode else {
                XCTFail("sceneNode should not be nil")
                return
            }
            guard let visualNode = link.visualNode else {
                XCTFail("visualNode should not be nil")
                return
            }
            
            //<origin rpy="0 0 0" xyz="0.015 0.025 0.035"/>
            XCTAssertTrue(sceneNode.position.x == 0.0, "x should be 0.025")
            XCTAssertTrue(sceneNode.position.y == 0.0, "y should be 0.025")
            XCTAssertTrue(sceneNode.position.z == 0.0, "z should be 0.025")
            // Test position of visual node
            XCTAssertTrue(abs(visualNode.position.x - 0.025) < 0.000001, "x should be 0.025")
            XCTAssertTrue(abs(visualNode.position.y - 0.035) < 0.000001, "y should be 0.035")
            XCTAssertTrue(abs(visualNode.position.z - 0.015) < 0.000001, "z should be 0.015")
            // Test orientation of visual node
            XCTAssertTrue(abs(visualNode.eulerAngles.x - 0.1) < 0.000001)
            XCTAssertTrue(abs(visualNode.eulerAngles.y - 0.2) < 0.000001)
            XCTAssertTrue(abs(visualNode.eulerAngles.z - 0.3) < 0.000001)
            
            // Test geometry of visual node
            guard let visualGeometry = visualNode.geometry as? SCNCylinder else {
                XCTFail("geometry should not be nil")
                return
            }
            XCTAssertEqual(visualGeometry.height, 0.05, "heigt should be 0.05")
            XCTAssertEqual(visualGeometry.radius, 0.1, "radius should be 0.1")
            
        } catch (let exception) {
            print(exception)
            XCTFail("should not throw exception")
        }
    }
    
    func testParseRobot() {
        guard let robotURDFData = loadURDF(fileName: "cougarbot") else {
            XCTFail("Couldn't find robot urdf")
            return
        }
        let parser = URDFParser()
        let indexer = SWXMLHash.parse(robotURDFData)
        do {
            guard let robot = try parser.parseRobot(indexer: indexer) else {
                XCTFail("Robot shouldn't be nil")
                return
            }
            XCTAssertNotNil(robot)
            let expectedLinkCount = 6
            let expectedJointCount = 5
            XCTAssertEqual(robot.links.count, expectedLinkCount)
            XCTAssertEqual(robot.joints.count, expectedJointCount)
            
            
            
        } catch (let exception) {
            print(exception)
            XCTFail("should not throw exception")
        }
    }
}
