//
//  Joint.swift
//  PinkGoat
//
//  Created by Roy Li on 3/20/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation

class Joint {
    
    let name: String
    let type: JointType
    let parentLinkName: String
    let childLinkName: String
    let origin: Origin
    
    init(name: String,
         type: JointType,
         parentLinkName: String,
         childLinkName: String,
         origin: Origin) {
        self.name = name
        self.type = type
        self.parentLinkName = parentLinkName
        self.childLinkName = childLinkName
        self.origin = origin
    }
    
    enum JointType {
        case continuous
        case revolute
        case prismatic
    }
    
    class func makeJointType(fromString str: String) -> Joint.JointType? {
        if str == "continuous" {
            return JointType.continuous
        } else if str == "revolute" {
            return JointType.revolute
        } else if str == "prismatic" {
            return JointType.prismatic
        } else {
            return nil
        }
    }
}
