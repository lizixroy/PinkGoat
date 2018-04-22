//
//  ViewController.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Cocoa
import SWXMLHash
import SceneKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testSceneKit()
    }
    
    func setup() {
        guard let scnView = self.view as? SCNView else {
            print("invalid scnView")
            return
        }
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        scnView.scene = scene
        scnView.backgroundColor = .black
        scnView.allowsCameraControl = true
    }
    
    func testSceneKit() {
        setup()
        guard let scnView = self.view as? SCNView else {
            print("invalid scnView")
            return
        }
        guard let scene = scnView.scene else {
            print("invalud scene")
            return
        }
        
        // world link
        let worldLink = SCNNode()
        scene.rootNode.addChildNode(worldLink)
        
        // base link
        let baseLinkGeometry = SCNCylinder(radius: 1, height: 0.5)
        let link = SCNNode()
        let linkVisual = SCNNode(geometry: baseLinkGeometry)
        linkVisual.position = SCNVector3(x: 0, y: 0.25, z: 0)
        link.addChildNode(linkVisual)
        worldLink.addChildNode(link)
        
        // base_link_torso_joint
        let baseLinkTorsoJoint = SCNNode()
        baseLinkTorsoJoint.position = SCNVector3(x:0, y:0.5, z:0)
        link.addChildNode(baseLinkTorsoJoint)
        
        // torso link
        let torsoLinkGeometry = SCNCylinder(radius: 0.5, height: 5)
        let torsoLink = SCNNode()
        let torsoLinkVisual = SCNNode(geometry: torsoLinkGeometry)
        torsoLinkVisual.position = SCNVector3(x: 0, y: 2.5, z: 0)
        torsoLink.addChildNode(torsoLinkVisual)
        baseLinkTorsoJoint.addChildNode(torsoLink)
        
        // torso_upper_arm_joint
        let joint = SCNNode()
        joint.position = SCNVector3(x: -1.0, y: 4.5, z: 0.0)
        joint.eulerAngles = SCNVector3(x: 1.5708, y: 0, z: 0)
        torsoLink.addChildNode(joint)
        
        // upper arm
        let upperArmGeometry = SCNCylinder(radius: 0.5, height: 4)
        let upperArmLink = SCNNode()
        let upperArmVisual = SCNNode(geometry: upperArmGeometry)
        upperArmVisual.position = SCNVector3(x: 0, y: 2, z: 0)
        upperArmLink.addChildNode(upperArmVisual)
        joint.addChildNode(upperArmLink)
        
        // upper_arm_lower_arm_joint
        let upper_arm_lower_arm_joint = SCNNode()
        upper_arm_lower_arm_joint.position = SCNVector3(x: 1, y: 3.5, z:0)
        upperArmLink.addChildNode(upper_arm_lower_arm_joint)
        
        // lower arm
        let lowerArmGeometry = SCNCylinder(radius: 0.5, height: 4)
        let lowerArmLink = SCNNode()
        let lowerArmLinkVisual = SCNNode(geometry: lowerArmGeometry)
        lowerArmLinkVisual.position = SCNVector3(x:0, y:2, z:0)
        lowerArmLink.addChildNode(lowerArmLinkVisual)
        upper_arm_lower_arm_joint.addChildNode(lowerArmLink)
        
        // wrist
        let wrist = SCNNode()
        wrist.position = SCNVector3(0, 4.25, 0)
        lowerArmLink.addChildNode(wrist)
        
        // hand
        let handGeometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        let handNode = SCNNode()
        let handNodeVisual = SCNNode(geometry: handGeometry)
        handNode.addChildNode(handNodeVisual)
        wrist.addChildNode(handNode)
    }
    
    func testParser() {
        guard let url = Bundle.main.url(forResource: "link-example", withExtension: "urdf") else {
            print("can't find file")
            return
        }
        guard let xmlData = try? Data(contentsOf: url) else {
            print("can't load xmlData")
            return
        }
        let indexer = SWXMLHash.parse(xmlData)
        let materialIndexer = indexer["link"]["visual"]["material"]
        let urdfParser = URDFParser()
        guard let material = try! urdfParser.parseMaterial(materialIndexer: materialIndexer) else {
            print("failed to parse origin")
            return
        }
        print("material: \(material)")
    }

    override var representedObject: Any? {
        didSet {
        }
    }

}

