//
//  Inertial.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

struct Intertial {
    let originReplacement: SCNVector3
    let originOrientation: SCNVector3
    let mass: Double
    let inertia: SCNMatrix4
}
