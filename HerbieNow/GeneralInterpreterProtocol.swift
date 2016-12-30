//
//  GeneralInterpreterProtocol.swift
//  HerbieNow
//
//  Created by Benno Kress on 21.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

// General interpreter is used by AppDelegate to send Location Updates to the interpreter of the currently active view
protocol GeneralInterpretProtocol {

    func locationUpdated(_ location: Location)

}
