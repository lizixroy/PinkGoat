//
//  URDFError.swift
//  PinkGoat
//
//  Created by Roy Li on 3/19/18.
//  Copyright © 2018 Roy Li. All rights reserved.
//

import Foundation

enum URDFError: Error {
    case originError(message: String)
    case geometryError(message: String)
    case materialError(message: String)
}
