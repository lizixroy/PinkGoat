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
