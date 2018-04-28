//
//  Geometry.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

enum Geometry {
    case cylinder(length: Double, radius: Double)
    case box(dim: SCNVector3)
    
    func toSceneKitGeometry() -> SCNGeometry {
        switch self {
        case .cylinder(let length, let radius):
            return SCNCylinder(radius: CGFloat(radius), height: CGFloat(length))
        case .box(let dim):
            return SCNBox(width: CGFloat(dim.x), height: CGFloat(dim.y), length: CGFloat(dim.z), chamferRadius: 0.0)
        }
    }
}
