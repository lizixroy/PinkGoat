//
//  URDFParser.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation
import SWXMLHash
import SceneKit

class URDFParser {
    
    // only parse visual information right now
    func parseLink(indexer: XMLIndexer) -> Link? {
        let visualInfo = indexer["link"]["visual"]
        guard let visual = parseVisual(indexer: visualInfo) else {
            // TODO: how to handle error?
            print("can't parse visual")
            return nil
        }
        return nil
    }
    
    func parseOrigin(indexer: XMLIndexer) -> (SCNVector3, SCNVector3)? {
        guard let originInfo = indexer.element else {
            print("cannot find originInfo")
            return nil
        }
        
        guard let rpy: String = try? originInfo.value(ofAttribute: "rpy") else {
            print("can't get rpy info")
            return nil
        }
        
        guard let xyz: String = try? originInfo.value(ofAttribute: "xyz") else {
            print("can't get xyz info")
            return nil
        }
        
        let rpyComponents = rpy.components(separatedBy: " ")
        assert(rpyComponents.count == 3)
        
        guard let row = Float(rpyComponents[0]) else {
            return nil
        }
        guard let pitch = Float(rpyComponents[1]) else {
            return nil
        }
        guard let yaw = Float(rpyComponents[2]) else {
            return nil
        }
        
        let xyzComponents = xyz.components(separatedBy: " ")
        assert(xyzComponents.count == 3)
        
        guard let x = Float(xyzComponents[0]) else {
            return nil
        }
        guard let y = Float(xyzComponents[1]) else {
            return nil
        }
        guard let z = Float(xyzComponents[2]) else {
            return nil
        }
        let displacement = SCNVector3(x: CGFloat(x),
                                      y: CGFloat(y),
                                      z: CGFloat(z))
        let orientation = SCNVector3(x: CGFloat(row),
                                     y: CGFloat(pitch),
                                     z: CGFloat(yaw))
        return (displacement, orientation)
    }
    
    func parseGeomotry(geometryIndexer: XMLIndexer) -> Geometry? {
        return nil
    }
    
    func parseVisual(indexer: XMLIndexer) -> Visual? {
//        let originInfo = ["origin"]
//        guard let rpy: String = try? originInfo.value(ofAttribute: "rpy") else {
//            print("can't get rpy info")
//            return nil
//        }
//
//        guard let xyz: String = try? originInfo.value(ofAttribute: "xyz") else {
//            print("can't get xyz info")
//            return nil
//        }
//        print("rpy: \(rpy)")
//        print("xyz: \(xyz)")
//
//        let rpyComponents = rpy.components(separatedBy: " ")
//        assert(rpyComponents.count == 3)
//
//        guard let row = Double(rpyComponents[0]) else {
//            return
//        }
//        guard let pitch = Double(rpyComponents[1]) else {
//            return
//        }
//        guard let yaw = Double(rpyComponents[2]) else {
//            return
//        }
//
//        let xyzComponents = xyz.components(separatedBy: " ")
//        assert(xyzComponents.count == 3)
//
//        guard let x = Double(xyzComponents[0]) else { return }
//        guard let y = Double(xyzComponents[1]) else { return }
//        guard let z = Double(xyzComponents[2]) else { return }
//
//        let geometryInfo = indexer["link"]["visual"]["geometry"]
//        print("geometryInfo: \(geometryInfo)")
//
//        let boxInfo = geometryInfo["box"]
//        guard let boxElement = boxInfo.element else {
//            print("no box element")
//            return
//        }
//        guard let size:String = try?boxElement.value(ofAttribute: "size") else {
//            print("can't find size")
//            return
//        }
//        print("size of box: \(size)")
        return nil
    }
}
