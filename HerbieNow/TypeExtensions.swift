//
//  TypeExtensions.swift
//  HerbieNow
//
//  Created by Benno Kress on 14.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

extension Dictionary {

    func appending(_ value: Value, forKey key: Key) -> [Key: Value] {
        var result = self
        result[key] = value
        return result
    }

}
