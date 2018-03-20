//
//  Visual.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

struct Visual {
    let originDisplacement: SCNVector3
    let originOrientation: SCNVector3
    let material: Material?
    let geometry: Geometry
}
