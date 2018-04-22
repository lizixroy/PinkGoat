//
//  Link.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

struct Link {
    var sceneNode: SCNNode?
    var visualNode: SCNNode? {
        return sceneNode?.childNodes.first
    }
    
    init(sceneNode: SCNNode? = nil) {
        self.sceneNode = sceneNode
    }
    
//    func visualize() -> SCNNode? {
//        //let geometry = SCNGeometry(sources: <#T##[SCNGeometrySource]#>, elements: <#T##[SCNGeometryElement]?#>)
//        return nil
//    }
}
