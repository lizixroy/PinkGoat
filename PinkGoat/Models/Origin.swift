//
//  Origin.swift
//  PinkGoat
//
//  Created by Roy Li on 3/20/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SceneKit

typealias Position = SCNVector3
typealias EulerAngles = SCNVector3

struct Origin {
    let xyz: SCNVector3
    let rpy: SCNVector3
    
    func toPositionAndEulerAngles() -> (position: Position, eulerAngles: EulerAngles) {
        let sceneKitOrigin = convertPositionFromURDFFrameToSceneKitFrame(vector: self.xyz)
        let rpy = self.rpy
        return (sceneKitOrigin, rpy)
    }
    
    private func convertPositionFromURDFFrameToSceneKitFrame(vector: SCNVector3) -> SCNVector3 {
        let x = vector.x
        let y = vector.y
        let z = vector.z
        return SCNVector3(y, z, x)
    }

}
