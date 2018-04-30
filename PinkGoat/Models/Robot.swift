//
//  Robot.swift
//  PinkGoat
//
//  Created by Roy Li on 4/22/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

class Robot {
    var links = [Link]()
    var joints = [Joint]()
    var sceneNode: SCNNode?
    
    init?(links: [Link], joints: [Joint]) {
        if links.count == 0 { return nil }
        self.links = links
        self.joints = joints
        if links.count > 0 {
            sceneNode = links[0].sceneNode
        }
        for joint in joints {
            let childLinkName = joint.childLinkName
            let parentLinkName = joint.parentLinkName
            guard let childLink = link(forName: childLinkName) else {
                print("Error creating robot: childLink named \(childLinkName) doesn't exist")
                return nil
            }
            guard let parentLink = link(forName: parentLinkName) else {
                print("Error creating robot: parentLink named \(parentLinkName) doesn't exist")
                return nil
            }
            print("adding joint: \(joint.name) to link: \(parentLink.name)")
            parentLink.sceneNode.addChildNode(joint.sceneNode)
            print("adding link: \(childLink.name) to joint: \(joint.name)")
            joint.sceneNode.addChildNode(childLink.sceneNode)
        }
    }
    
    func joint(forName name: String) -> Joint? {
        for joint in joints {
            if joint.name == name {
                return joint
            }
        }
        return nil
    }
    
    func link(forName name: String) -> Link? {
        for link in links {
            if link.name == name {
                return link
            }
        }
        return nil
    }
}
