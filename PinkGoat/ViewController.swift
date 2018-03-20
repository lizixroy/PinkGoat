//
//  ViewController.swift
//  PinkGoat
//
//  Created by Roy Li on 3/17/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Cocoa
import SWXMLHash
import SceneKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "link-example", withExtension: "urdf") else {
            print("can't find file")
            return
        }
        guard let xmlData = try? Data(contentsOf: url) else {
            print("can't load xmlData")
            return
        }
        let indexer = SWXMLHash.parse(xmlData)
        
        let materialIndexer = indexer["link"]["visual"]["material"]
        
        let urdfParser = URDFParser()
        guard let material = try! urdfParser.parseMaterial(materialIndexer: materialIndexer) else {
            print("failed to parse origin")
            return
        }
        print("material: \(material)")
    }

    override var representedObject: Any? {
        didSet {
        }
    }

}

