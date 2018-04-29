//
//  Link.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

class Link {
    let name: String
    var sceneNode: SCNNode?
    var visualNode: SCNNode? {
        return sceneNode?.childNodes.first
    }
    
    init(name: String? = nil, sceneNode: SCNNode? = nil) {
        self.name = name ?? ""
        self.sceneNode = sceneNode ?? SCNNode()
    }
    
//    func visualize() -> SCNNode? {
//        //let geometry = SCNGeometry(sources: <#T##[SCNGeometrySource]#>, elements: <#T##[SCNGeometryElement]?#>)
//        return nil
//    }
}
