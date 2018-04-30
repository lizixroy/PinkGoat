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
    
    func parseRobot(indexer: XMLIndexer) throws -> Robot? {
        let robotIndexer = indexer["robot"]
        if robotIndexer.element == nil {
            throw URDFError.error(message: "<robot> is missing")
        }
        let linkIndexer = robotIndexer["link"]
        var links = [Link]()
        var joints = [Joint]()
        for linkURDF in linkIndexer.all {
            if let link = try parseLink(indexer: linkURDF) {
                links.append(link)
            }
        }
        let jointIndexer = robotIndexer["joint"]
        for jointURDF in jointIndexer.all {
            if let joint = try parseJoint(jointIndexer: jointURDF) {
                joints.append(joint)
            }
        }
        return Robot(links: links, joints: joints)
    }
    
    /**
        NOTE: right now only parse the following attributes:
        axis, parent, child, origin
     */
    
    func parseJoint(jointIndexer: XMLIndexer) throws -> Joint? {
        guard let name: String = jointIndexer.value(ofAttribute: "name") else {
            throw URDFError.jointError(message: "Name is missing")
        }
        guard let typeStr: String = jointIndexer.value(ofAttribute: "type") else {
            throw URDFError.jointError(message: "Type is missing")
        }
        guard let type = Joint.makeJointType(fromString: typeStr) else {
            throw URDFError.jointError(message: "Invalid joint type: \(typeStr)")
        }
        
        let parentIndexer = jointIndexer["parent"]
        let childIndexer = jointIndexer["child"]
        guard let parentLinkName: String = parentIndexer.value(ofAttribute: "link") else {
            throw URDFError.jointError(message: "Couldn't find parent")
        }
        guard let childLinkName: String = childIndexer.value(ofAttribute: "link") else {
            throw URDFError.jointError(message: "Couldn't find child")
        }
        
        let originIndexer = jointIndexer["origin"]
        let origin = try parseOrigin(originIndexer: originIndexer)
        
        return Joint(name: name, type: type, parentLinkName: parentLinkName, childLinkName: childLinkName, origin: origin)
    }
    
    // only parse visual information right now
    func parseLink(indexer: XMLIndexer) throws -> Link? {
        let name: String? = try? indexer.value(ofAttribute: "name")
        let link = Link(name: name, sceneNode: nil)
        let originIndexer = indexer["visual"]["origin"]
        let origin = try parseOrigin(originIndexer: originIndexer)
        let geometry = try parseGeometry(geometryIndexer: indexer["visual"]["geometry"])
        let visualNode = SCNNode()
        visualNode.geometry = geometry?.toSceneKitGeometry()
        if let origin = origin {
            let sceneKitOrigin = convertPositionFromURDFFrameToSceneKitFrame(vector: origin.xyz)
            let rpy = origin.rpy
            visualNode.position = sceneKitOrigin
            visualNode.eulerAngles = rpy
        }
        link.sceneNode.addChildNode(visualNode)
        return link
    }
    
    // TODO: NEED to give type info to return value so it' easier for caller to differentiate between different values.
    func parseOrigin(originIndexer: XMLIndexer) throws -> Origin? {
        guard let originInfo = originIndexer.element else {
            return nil
        }
        
        guard let rpy: String = try? originInfo.value(ofAttribute: "rpy") else {
            throw URDFError.originError(message: "Couldn't find rpy")
        }
        
        guard let xyz: String = try? originInfo.value(ofAttribute: "xyz") else {
            throw URDFError.originError(message: "Couldn't find xyz")
        }
        
        let rpyComponents = rpy.components(separatedBy: " ")
        guard rpyComponents.count == 3 else {
            throw URDFError.originError(message: "rpy attribute is malformed: \(rpy)")
        }
        
        guard let row = Float(rpyComponents[0]) else {
            throw URDFError.originError(message: "Row of rpy attribute is malformed: \(rpyComponents[0])")
        }
        guard let pitch = Float(rpyComponents[1]) else {
            throw URDFError.originError(message: "Pitch of rpy attribute is malformed: \(rpyComponents[1])")
        }
        guard let yaw = Float(rpyComponents[2]) else {
            throw URDFError.originError(message: "Yaw of rpy attribute is malformed: \(rpyComponents[2])")
        }
        
        let xyzComponents = xyz.components(separatedBy: " ")
        assert(xyzComponents.count == 3)
        
        guard let x = Float(xyzComponents[0]) else {
            throw URDFError.originError(message: "x of xyz attribute is malformed: \(xyzComponents[0])")
        }
        guard let y = Float(xyzComponents[1]) else {
            throw URDFError.originError(message: "y of xyz attribute is malformed: \(xyzComponents[1])")
        }
        guard let z = Float(xyzComponents[2]) else {
            throw URDFError.originError(message: "z of xyz attribute is malformed: \(xyzComponents[2])")
        }
        let displacement = SCNVector3(x: CGFloat(x),
                                      y: CGFloat(y),
                                      z: CGFloat(z))
        let orientation = SCNVector3(x: CGFloat(row),
                                     y: CGFloat(pitch),
                                     z: CGFloat(yaw))
        
        return Origin(xyz: displacement, rpy: orientation)
    }
    
    func parseGeometry(geometryIndexer: XMLIndexer) throws -> Geometry? {
        guard let geometryInfo = geometryIndexer.element else {
            return nil
        }
        let cylinderInfo = geometryIndexer["cylinder"]
        if cylinderInfo.element != nil {
            guard let radiusStr: String = cylinderInfo.value(ofAttribute: "radius") else {
                throw URDFError.geometryError(message: "Couldn't find radius")
            }
            guard let lengthStr: String = cylinderInfo.value(ofAttribute: "length") else {
                throw URDFError.geometryError(message: "Couldn't find length")
            }
            guard let radius = Double(radiusStr) else {
                throw URDFError.geometryError(message: "radius is malformed: \(radiusStr)")
            }
            guard let length = Double(lengthStr) else {
                throw URDFError.geometryError(message: "length is malformed: \(lengthStr)")
            }
            return Geometry.cylinder(length: length, radius: radius)
        }
        let boxInfo = geometryIndexer["box"]
        if boxInfo.element != nil {
            guard let size: String = boxInfo.value(ofAttribute: "size") else {
                throw URDFError.geometryError(message: "Couldn't find size for box")
            }
            let sizeComponents = size.components(separatedBy: " ")
            guard sizeComponents.count == 3 else {
                throw URDFError.geometryError(message: "Malformed size string for box")
            }
            guard let width = Double(sizeComponents[0]) else {
                throw URDFError.geometryError(message: "width needs to be numerical")
            }
            guard let height = Double(sizeComponents[1]) else {
                throw URDFError.geometryError(message: "height needs to be numerical")
            }
            guard let length = Double(sizeComponents[2]) else {
                throw URDFError.geometryError(message: "length needs to be numerical")
            }
            return Geometry.box(dim: SCNVector3(x: CGFloat(width), y: CGFloat(height), z: CGFloat(length)))
        }
        throw URDFError.geometryError(message: "Found invalid geometry type: \(geometryInfo)")
    }
    
    func parseMaterial(materialIndexer: XMLIndexer) throws -> Material? {
        if materialIndexer.element == nil {
            return nil
        }
        let name: String? = materialIndexer.value(ofAttribute: "name")
        let colorIndexer = materialIndexer["color"]
        let color = try parseColor(colorIndexer: colorIndexer)
        if name != nil || color != nil {
            return Material(name: name, color: color, filepath: nil)
        }
        if let filePath = materialIndexer.element?.text {
            return Material(name: nil, color: nil, filepath: filePath)
        }
        return nil
    }
    
    private func parseColor(colorIndexer: XMLIndexer) throws -> CGColor? {
        guard colorIndexer.element != nil else {
            return nil
        }
        guard let colorStr: String = try? colorIndexer.value(ofAttribute: "rgba") else {
            return nil
        }
        let colorComponents = colorStr.components(separatedBy: " ")
        guard colorComponents.count == 4 else {
            throw URDFError.materialError(message: "rgba is malformed: \(colorStr)")
        }
        let rStr = colorComponents[0]
        let gStr = colorComponents[1]
        let bStr = colorComponents[2]
        let aStr = colorComponents[3]
        guard let red = Float(rStr) else {
            throw URDFError.materialError(message: "Red channel is malformed: \(rStr)")
        }
        guard let green = Float(gStr) else {
            throw URDFError.materialError(message: "Green channel is malfored: \(gStr)")
        }
        guard let blue = Float(bStr) else {
            throw URDFError.materialError(message: "Blue channel is malformed: \(bStr)")
        }
        guard let alpha = Float(aStr) else {
            throw URDFError.materialError(message: "Alpha channel is malformed: \(aStr)")
        }
        return CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    func convertPositionFromURDFFrameToSceneKitFrame(vector: SCNVector3) -> SCNVector3 {
        let x = vector.x
        let y = vector.y
        let z = vector.z
        return SCNVector3(y, z, x)
    }
}
