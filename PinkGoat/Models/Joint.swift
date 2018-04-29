//
//  Joint.swift
//  PinkGoat
//
//  Created by Roy Li on 3/20/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

class Joint {
    
    let name: String
    let type: JointType
    let parentLinkName: String
    let childLinkName: String
    let origin: Origin?
    let sceneNode: SCNNode
    
    init(name: String,
         type: JointType,
         parentLinkName: String,
         childLinkName: String,
         origin: Origin?) {
        self.name = name
        self.type = type
        self.parentLinkName = parentLinkName
        self.childLinkName = childLinkName
        self.origin = origin
        sceneNode = SCNNode()
        if let origin = origin {
            let positionAndeulerAngles = origin.toPositionAndEulerAngles()
            sceneNode.position = positionAndeulerAngles.position
            sceneNode.eulerAngles = positionAndeulerAngles.eulerAngles
        }
    }
    
    enum JointType {
        case continuous
        case revolute
        case prismatic
        case fixed
    }
    
    class func makeJointType(fromString str: String) -> Joint.JointType? {
        if str == "continuous" {
            return .continuous
        } else if str == "revolute" {
            return .revolute
        } else if str == "prismatic" {
            return .prismatic
        } else if str == "fixed" {
            return .fixed
        } else {
            return nil
        }
    }
}

