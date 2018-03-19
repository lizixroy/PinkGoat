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
}
