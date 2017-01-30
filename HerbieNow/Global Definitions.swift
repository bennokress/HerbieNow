//
//  Global Definitions.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import Foundation
import SwifterSwift

typealias Callback = (APICallResult) -> Void
typealias Success = Bool

let today = Date()

/// Get the class name by calling name(of: self) in any class function
func name(of object: Any) -> String {
    return (object is Any.Type) ? "\(object)" : "\(type(of: object))"
}

func funcID(class classObject: Any, func functionName: String) -> String {
    let className = name(of: classObject)
    return "\(className).\(functionName.until("("))"
}
