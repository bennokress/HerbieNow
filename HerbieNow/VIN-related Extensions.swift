//
//  VINExtensions.swift
//  HerbieNow
//
//  Created by Benno Kress on 19.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

extension Int {
    
    // kW to horse power conversion
    func inHP() -> Int {
        return Int(Double(self) * 1.35962)
    }
    
}

extension String {
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript(range: CountableRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]
    }
    
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]
    }
    
    // MARK: - VIN decoding
    
    private var modelID: String {
        return self[3...6] // The characters 4-7 of the vehicle identification number are its model
    }
    
    var makeID: String {
        return self[0...2] // The first 3 characters of the vehicle identification number are its manufacturer
    }
    
    private var engineID: String {
        return self[7...8] // Smart have their engine information at character 8 and 9 of the vehicle identification number
    }
    
    var make: Make {
        
        return Make(fromVIN: self)
        
    }
    
    var model: Model {
        
        switch self.modelID {
            
        // DriveNow
        case "UA11", "UA31", "UA51", "UA71", "UB11", "UB31", "UB51", "UB71", "UB91", "UK11", "UK31", "UK51": return .bmw1er3Door                                                     // E81 - 3 Door
        case "UC11", "UC31", "UC51", "UC71", "UC91", "UR11", "UR31", "UR51", "UR91": return .bmw1erCoupe                                                                             // E82
        case "UP31": return .bmwActiveE                                                                                                                                              // E82 - ActiveE
        case "VL31", "VL51", "VL91", "VM11", "VM31", "VM71", "VM91", "VN11", "VN31", "VN71", "VN91", "VP11", "VP31", "VP51", "VP71", "VP91", "VX11", "VY11", "VZ91": return .bmwX1   // E84
        case "UD11", "UD31", "UD51", "UD71", "UD91", "UE11", "UE31", "UE51", "UE71", "UF11", "UF31", "UF51", "UF91", "UG31", "UG51", "UH11", "UH31", "UH51": return .bmw1er5Door     // E87 - 5 Door
        case "UL51", "UL91", "UM11", "UM31", "UM51", "UM71", "UM91", "UN71", "UN91", "UP11": return .bmw1erConvertible                                                               // E88
        case "1A11", "1A31", "1A51", "1B51", "1B71", "1B91", "1C11", "1C31", "1C51", "1C71", "1C91", "1R11", "1R51", "1S51", "1S71", "1T11", "1T31", "1T51", "1T91", "1U51",
             "1U71", "1U91", "1V11", "1V31", "1V51", "1V71", "1V91", "2R11", "2R31", "2R51": return .bmw1er5Door                                                                     // F20 - 5 Door
        case "1D11", "1D31", "1D51", "1E11", "1E31", "1E51", "1E71", "1N11", "1N31", "1N51", "1N71", "1N91", "1P11", "1P51", "1W51", "1W71", "1X11", "1X31", "1X51", "1Y11",
             "1Y31", "1Y51", "1Y71", "1Y91", "2P11", "2P31", "2P51", "2P71", "2P91", "2S11": return .bmw1er3Door                                                                     // F21 - 3 Door
        case "1F51", "1H11", "1H31", "1H71", "1J11", "1J71", "1J91", "2F11", "2G51", "2G71", "2G91", "2H11": return .bmw2erCoupe                                                     // F22
        case "1K51", "1L71", "1M11", "1M31", "1M51", "2L51", "2L71", "2L91": return .bmw2erConvertible                                                                               // F23
        case "2A31", "2A51", "2A71", "2A91", "2B11", "2B31", "2B91", "2C11", "2C31", "2C51", "2C71", "2X71": return .bmw2erAT                                                        // F45
        case "2D31", "2D51", "2D71", "2D91", "2E31", "2E51", "2E71": return .bmw2erGT                                                                                                // F46
        case "HS11", "HS71", "HS91", "HT11", "HT51", "HT71", "HT91", "HU11", "HU31", "HU51": return .bmwX1                                                                           // F48
        case "LN31", "LN51", "LN71", "LN91", "LR51", "LR71", "LR91", "LU31", "LU71", "LU91": return .miniClubman                                                                     // F54
        case "XS11", "XS51", "XS71", "XS91", "XT11", "XT31", "XT71", "XT91", "XU11", "XU31": return .mini5Door                                                                       // F55
        case "XM51", "XM71", "XM91", "XN11", "XN31", "XN71", "XN91", "XP11", "XP51", "XP51": return .mini3Door                                                                       // F56
        case "WG11", "WG31", "WG51", "WG71", "WH31", "WH51", "WH91": return .miniConvertible                                                                                         // F57
        // F60
        case "1Z21", "1Z41": return .bmwI3                                                                                                                                           // I01
        case "RA11", "RA31", "RB11", "RC31": return .mini3Door                                                                                                                       // R50
        case "RD31", "RF31", "RH31": return .miniConvertible                                                                                                                         // R52
        case "RE31", "RE91": return .mini3Door                                                                                                                                       // R53
        case "MH31", "MH91", "ML31", "MM31", "MM91", "MN51", "XE51", "ZE31", "ZF31", "ZG31", "ZG91", "ZH11", "ZH51", "ZH71": return .miniClubman                                     // R55
        case "ME31", "MF31", "MF71", "MF91", "MG31", "MG51", "SR11", "SR31", "SR51", "SR81", "SU31", "SU91", "SV31", "SV91", "SW11", "SW31", "SW51", "SW71": return .mini3Door       // R56
        case "MR31", "MR91", "MS31", "XF31", "MS91", "ZM31", "ZN31", "ZP31", "ZP91", "ZR31", "ZR71": return .miniConvertible                                                         // R57
        case "SX11", "SX31", "SX51", "SX71", "SX91": return .miniCoupe                                                                                                               // R58
        case "SY11", "SY31", "SY51", "SY71", "SY91": return .miniRoadster                                                                                                            // R59
        case "XD11", "XD31", "XD51", "XD71", "ZA31", "ZB31", "ZB51", "ZB71", "ZC31", "ZC51", "ZD11", "ZD31", "ZD51", "ZD71": return .miniCountryman                                  // R60
        case "RJ51", "RJ71", "RS11", "RS31", "RS51", "RS71", "RS91", "SS11", "SS31", "SS51", "SS71", "SS91": return .miniPaceman                                                     // R61
            
        // Car2Go
        case "4503", "4504", "4513", "4514": return .smartForTwo
        case "4523", "4524": return .smartRoadster
        case "4533", "4534": return .smartForFour
            // TODO: Fix decoding for smart
            
        case "1760": return .mercedesAclass
//            case "1569": return .mercedesBclass
            // TODO: Complete decoding for Mercedes-Benz
            
        default: return .unknown
        
        }
        
    }
    
    var kW: Int {
        
        if self.make == .bmw || self.make == .mini {
            
            switch self.modelID {
                
            // E81 BMW 1er 3 Door (2007)
            case "UA11": return 85  // BMW 116i 3 Door
            case "UA31": return 100 // BMW 118i 3 Door
            case "UA51": return 115 // BMW 120i 3 Door
            case "UA71": return 125 // BMW 120i 3 Door
            case "UB11": return 190 // BMW 130i 3 Door
            case "UB31": return 105 // BMW 118d 3 Door
            case "UB51": return 130 // BMW 120d 3 Door
            case "UB71": return 90  // BMW 116i 3 Door
            case "UB91": return 105 // BMW 118i 3 Door
            case "UK11": return 150 // BMW 123d 3 Door
            case "UK31": return 90  // BMW 116d 3 Door
            case "UK51": return 85  // BMW 116d 3 Door
                
            // E82 BMW 1er Coupé (2007)
            case "UC11": return 125 // BMW 120i Coupé
            case "UC31": return 160 // BMW 125i Coupé
            case "UC51": return 115 // BMW 120i Coupé
            case "UC71": return 225 // BMW 135is Coupé
            case "UC91": return 225 // BMW 135i Coupé
            case "UP31": return 120 // BMW ActiveE
            case "UR11": return 105 // BMW 118d Coupé
            case "UR31": return 130 // BMW 120d Coupé
            case "UR51": return 150 // BMW 123d Coupé
            case "UR91": return 250 // BMW M1 Coupé
                
            // E84 BMW X1 (2009)
            case "VL31": return 110 // BMW X1 sDrive18i
            case "VL51": return 160 // BMW X1 xDrive25i
            case "VL91": return 135 // BMW X1 sDrive20i
            case "VM11": return 180 // BMW X1 xDrive28i
            case "VM31": return 190 // BMW X1 xDrive28i
            case "VM71": return 160 // BMW X1 xDrive25d
            case "VM91": return 135 // BMW X1 xDrive20i
            case "VN11": return 105 // BMW X1 sDrive18d
            case "VN31": return 130 // BMW X1 sDrive20d
            case "VN71": return 105 // BMW X1 sDrive18d
            case "VN91": return 135 // BMW X1 sDrive20d
            case "VP11": return 105 // BMW X1 xDrive18d
            case "VP31": return 130 // BMW X1 xDrive20d
            case "VP51": return 150 // BMW X1 xDrive23d
            case "VP71": return 105 // BMW X1 xDrive18d
            case "VP91": return 135 // BMW X1 xDrive20d
            case "VX11": return 105 // BMW X1 sDrive16i
            case "VY11": return 85  // BMW X1 sDrive16d
            case "VZ91": return 120 // BMW X1 sDrive20d EfficientDynamics Edition
                
            // E87 BMW 1er 5 Door (2004)
            case "UD11": return 125 // BMW 120i 5 Door (LCI)
            case "UD31": return 115 // BMW 120i 5 Door (LCI)
            case "UD51": return 190 // BMW 130i 5 Door (LCI)
            case "UD71": return 105 // BMW 118d 5 Door (LCI)
            case "UD91": return 130 // BMW 120d 5 Door (LCI)
            case "UE11": return 85  // BMW 116i 5 Door (LCI)
            case "UE31": return 90  // BMW 116i 5 Door (LCI)
            case "UE51": return 105 // BMW 118i 5 Door (LCI)
            case "UE71": return 100 // BMW 118i 5 Door (LCI)
            case "UF11": return 85  // BMW 116i 5 Door
            case "UF31": return 95  // BMW 118i 5 Door
            case "UF51": return 110 // BMW 120i 5 Door
            case "UF91": return 195 // BMW 130i 5 Door
            case "UG31": return 90  // BMW 118d 5 Door
            case "UG51": return 120 // BMW 120d 5 Door
            case "UH11": return 150 // BMW 123d 5 Door (LCI)
            case "UH31": return 90  // BMW 116i 5 Door (LCI)
            case "UH51": return 85  // BMW 116d 5 Door (LCI)
                
            // E88 BMW 1er Cabrio (2008)
            case "UL51": return 115 // BMW 120i Cabrio
            case "UL91": return 160 // BMW 125i Cabrio
            case "UM11": return 105 // BMW 118i Cabrio
            case "UM31": return 100 // BMW 118i Cabrio
            case "UM51": return 125 // BMW 120i Cabrio
            case "UM71": return 130 // BMW 120d Cabrio
            case "UM91": return 105 // BMW 118d Cabrio
            case "UN71": return 225 // BMW 135i Cabrio
            case "UN91": return 225 // BMW 135i Cabrio
            case "UP11": return 150 // BMW 123d Cabrio
                
            // F20 BMW 1er 5 Door (2011)
            case "1A11": return 100 // BMW 116i 5 Door
            case "1A31": return 125 // BMW 118i 5 Door
            case "1A51": return 160 // BMW 125i 5 Door
            case "1B51": return 135 // BMW 120d 5 Door xDrive
            case "1B71": return 235 // BMW M135i 5 Door
            case "1B91": return 235 // BMW M135i 5 Door xDrive
            case "1C11": return 105 // BMW 118d 5 Door
            case "1C31": return 135 // BMW 120d 5 Door
            case "1C51": return 160 // BMW 125d 5 Door
            case "1C71": return 85  // BMW 116d 5 Door
            case "1C91": return 85  // BMW 116d 5 Door EfficientDynamics Edition
            case "1R11": return 75  // BMW 114i 5 Door
            case "1R51": return 100 // BMW 118i 5 Door
            case "1S51": return 110 // BMW 118d 5 Door
            case "1S71": return 140 // BMW 120d 5 Door
            case "1T11": return 140 // BMW 120d 5 Door xDrive
            case "1T31": return 165 // BMW 125d 5 Door
            case "1T51": return 105 // BMW 118d 5 Door xDrive
            case "1T91": return 70  // BMW 114d 5 Door
            case "1U51": return 110 // BMW 118d 5 Door xDrive
            case "1U71": return 130 // BMW 120i 5 Door
            case "1U91": return 160 // BMW 125i 5 Door
            case "1V11": return 240 // BMW M135i 5 Door
            case "1V31": return 240 // BMW M135i 5 Door xDrive
            case "1V51": return 70  // BMW 114d 5 Door
            case "1V71": return 85  // BMW 116d 5 Door
            case "1V91": return 85  // BMW 114d 5 Door EfficientDynamics Edition
            case "2R11": return 80  // BMW 116i 5 Door
            case "2R31": return 100 // BMW 118i 5 Door
            case "2R51": return 70  // BMW 114d 5 Door
                
            // F21 BMW 1er 3 Door (2012)
            case "1D11": return 100 // BMW 116i 3 Door
            case "1D31": return 125 // BMW 118i 3 Door
            case "1D51": return 160 // BMW 125i 3 Door
            case "1E11": return 105 // BMW 118d 3 Door
            case "1E31": return 135 // BMW 120d 3 Door
            case "1E51": return 135 // BMW 120d xDrive 3 Door
            case "1E71": return 160 // BMW 125d 3 Door
            case "1N11": return 85  // BMW 116d 3 Door
            case "1N31": return 85  // BMW 116d EfficientDynamics Edition 3 Door
            case "1N51": return 70  // BMW 114d 3 Door
            case "1N71": return 235 // BMW M135i 3 Door
            case "1N91": return 235 // BMW M135i xDrive 3 Door
            case "1P11": return 75  // BMW 114i 3 Door
            case "1P51": return 100 // BMW 118i 3 Door
            case "1W51": return 110 // BMW 118d 3 Door
            case "1W71": return 140 // BMW 120d 3 Door
            case "1X11": return 140 // BMW 120d xDrive 3 Door
            case "1X31": return 165 // BMW 125d 3 Door
            case "1X51": return 105 // BMW 118d xDrive 3 Door
            case "1Y11": return 130 // BMW 120i 3 Door
            case "1Y31": return 160 // BMW 125i 3 Door
            case "1Y51": return 110 // BMW 118d xDrive 3 Door
            case "1Y71": return 240 // BMW M135i 3 Door
            case "1Y91": return 240 // BMW M135i xDrive 3 Door
            case "2P11": return 70  // BMW 114d 3 Door
            case "2P31": return 85  // BMW 116d 3 Door
            case "2P51": return 85  // BMW 116d EfficientDynamics Edition 3 Door
            case "2P71": return 80  // BMW 116i 3 Door
            case "2P91": return 100 // BMW 118i 3 Door
            case "2S11": return 70  // BMW 114d 3 Door
                
            // F22 BMW 2er Coupé (2014)
            case "1F51": return 180 // BMW 228i Coupé
            case "1H11": return 135 // BMW 220d Coupé
            case "1H31": return 105 // BMW 218d Coupé
            case "1H71": return 160 // BMW 225d Coupé
            case "1J11": return 135 // BMW 220i Coupé
            case "1J71": return 240 // BMW M235i Coupé
            case "1J91": return 240 // BMW M235i xDrive Coupé
            case "2F11": return 100 // BMW 218i Coupé
            case "2G51": return 110 // BMW 218d Coupé
            case "2G71": return 140 // BMW 220d Coupé
            case "2G91": return 140 // BMW 220d xDrive Coupé
            case "2H11": return 165 // BMW 225d Coupé
                
            // F23 BMW 2er Cabrio (2014)
            case "1K51": return 180 // BMW 228i Cabrio
            case "1L71": return 135 // BMW 220i Cabrio
            case "1M11": return 240 // BMW M235i Cabrio
            case "1M31": return 100 // BMW 218i Cabrio
            case "1M51": return 240 // BMW M235i xDrive Cabrio
            case "2L51": return 110 // BMW 218d Cabrio
            case "2L71": return 140 // BMW 220d Cabrio
            case "2L91": return 165 // BMW 225d Cabrio
                
            // F45 BMW 2er Active Tourer (2014)
            case "2A31": return 100 // BMW 218i Active Tourer
            case "2A51": return 141 // BMW 220i Active Tourer
            case "2A71": return 170 // BMW 225i Active Tourer
            case "2A91": return 170 // BMW 225i xDrive Active Tourer
            case "2B11": return 70  // BMW 214d Active Tourer
            case "2B31": return 85  // BMW 216d Active Tourer
            case "2B91": return 110 // BMW 218d xDrive Active Tourer
            case "2C11": return 110 // BMW 218d Active Tourer
            case "2C31": return 140 // BMW 220d Active Tourer
            case "2C51": return 140 // BMW 220d xDrive Active Tourer
            case "2C71": return 165 // BMW 225xe Active Tourer
            case "2X71": return 75  // BMW 216i Active Tourer
                
            // F46 BMW 2er Grand Tourer (2015)
            case "2D31": return 100 // BMW 218i Grand Tourer
            case "2D51": return 141 // BMW 220i Grand Tourer
            case "2D71": return 140 // BMW 220d xDrive Grand Tourer
            case "2D91": return 75  // BMW 216i Grand Tourer
            case "2E31": return 85  // BMW 216d Grand Tourer
            case "2E51": return 110 // BMW 218d Grand Tourer
            case "2E71": return 140 // BMW 220d Grand Tourer
                
            // F48 BMW X1 (2015)
            case "HS11": return 100 // BMW X1 sDrive18i
            case "HS71": return 141 // BMW X1 sDrive20i
            case "HS91": return 141 // BMW X1 xDrive20i
            case "HT11": return 170 // BMW X1 xDrive25i
            case "HT51": return 85  // BMW X1 sDrive16d
            case "HT71": return 110 // BMW X1 sDrive18d
            case "HT91": return 110 // BMW X1 xDrive18d
            case "HU11": return 140 // BMW X1 sDrive20d
            case "HU31": return 140 // BMW X1 xDrive20d
            case "HU51": return 170 // BMW X1 xDrive25d
                
            // F54 MINI Clubman (2015)
            case "LN31": return 100 // MINI Cooper Clubman
            case "LN51": return 100 // MINI Cooper Clubman
            case "LN71": return 141 // MINI Cooper S Clubman
            case "LN91": return 141 // MINI Cooper S Clubman
            case "LR51": return 140 // MINI Cooper SD Clubman
            case "LR71": return 85  // MINI One D Clubman
            case "LR91": return 110 // MINI Cooper D Clubman
            case "LU31": return 141 // MINI Cooper S ALL4 Clubman
            case "LU71": return 140 // MINI Cooper SD All4 Clubman
            case "LU91": return 75  // MINI One Clubman
                
            // F55 MINI 5 Door (2014)
            case "XS11": return 75  // MINI One (5 Door)
            case "XS51": return 100 // MINI Cooper (5 Door)
            case "XS71": return 141 // MINI Cooper S (5 Door)
            case "XS91": return 55  // MINI One First (5 Door)
            case "XT11": return 70  // MINI One D (5 Door)
            case "XT31": return 85  // MINI Cooper D (5 Door)
            case "XT71": return 125 // MINI Cooper SD (5 Door)
            case "XT91": return 125 // MINI Cooper SD (5 Door)
            case "XU11": return 100 // MINI Cooper (5 Door)
            case "XU31": return 141 // MINI Cooper S (5 Door)
                
            // F56 MINI 3 Door (2014)
            case "XM51": return 100 // MINI Cooper
            case "XM71": return 141 // MINI Cooper S
            case "XM91": return 170 // MINI John Cooper Works
            case "XN11": return 70  // MINI One D
            case "XN31": return 85  // MINI Cooper D
            case "XN71": return 75  // MINI One
            case "XN91": return 125 // MINI Cooper SD
            case "XP11": return 55  // MINI One First
            case "XP51": return 100 // MINI Cooper
            case "XP51": return 141 // MINI Cooper S
                
            // F57 MINI Cabrio (2016)
            case "WG11": return 75  // MINI One Cabrio
            case "WG31": return 100 // MINI Cooper Cabrio
            case "WG51": return 100 // MINI Cooper Cabrio
            case "WG71": return 141 // MINI Cooper S Cabrio
            case "WH31": return 85  // MINI Cooper D Cabrio
            case "WH51": return 125 // MINI Cooper SD Cabrio
            case "WH91": return 170 // MINI John Cooper Works Cabrio
                
            // F60 MINI Countryman (2017)
                
            // I01 BMW i3 (2013)
            case "1Z21": return 125 // BMW i3
            case "1Z41": return 125 // BMW i3 REx
                
            // R50 MINI 3 Door (2001)
            case "RA11": return 55  // MINI One (1.4i)
            case "RA31": return 66  // MINI One (1.6i)
            case "RB11": return 65  // MINI One (1.4d)
            case "RC31": return 85  // MINI Cooper
                
            // R52 MINI Cabrio (2004)
            case "RD31": return 66  // MINI One Cabrio (1.6i)
            case "RF31": return 85  // MINI Cooper Cabrio
            case "RH31": return 125 // MINI Cooper S Cabrio
                
            // R53 MINI Cooper S (2002)
            case "RE31": return 125 // MINI Cooper S
            case "RE91": return 160 // MINI John Cooper Works
                
            // R55 MINI Clubman (2007)
            case "MH31": return 70  // MINI One Clubman
            case "MH91": return 155 // MINI John Cooper Works Clubman
            case "ML31": return 88  // MINI Cooper Clubman
            case "MM31": return 128 // MINI Cooper S Clubman
            case "MM91": return 155 // MINI John Cooper Works Clubman
            case "MN51": return 80  // MINI Cooper D Clubman
            case "XE51": return 82  // MINI Cooper D Clubman (LCI)
            case "ZE31": return 72  // MINI One Clubman (LCI)
            case "ZF31": return 90  // MINI Cooper Clubman (LCI)
            case "ZG31": return 135 // MINI Cooper S Clubman (LCI)
            case "ZG91": return 155 // MINI John Cooper Works Clubman (LCI)
            case "ZH11": return 66  // MINI One D Clubman (LCI)
            case "ZH51": return 82  // MINI Cooper D Clubman (LCI)
            case "ZH71": return 105 // MINI Cooper SD Clubman (LCI)
                
            // R56 MINI 3 Door (2006)
            case "ME31": return 70  // MINI One
            case "MF31": return 88  // MINI Cooper
            case "MF71": return 128 // MINI Cooper S
            case "MF91": return 155 // MINI John Cooper Works
            case "MG31": return 80  // MINI Cooper D
            case "MG51": return 66  // MINI One D
            case "SR11": return 55  // MINI One Minimalism (LCI)
            case "SR31": return 72  // MINI One (LCI)
            case "SR51": return 72  // MINI One (LCI)
            case "SR81": return 55  // MINI One Minimalism (LCI)
            case "SU31": return 90  // MINI Cooper (LCI)
            case "SU91": return 155 // MINI John Cooper Works (LCI)
            case "SV31": return 135 // MINI Cooper S (LCI)
            case "SV91": return 155 // MINI John Cooper Works (LCI)
            case "SW11": return 66  // MINI One D (LCI)
            case "SW31": return 82  // MINI Cooper D (LCI)
            case "SW51": return 82  // MINI Cooper D (LCI)
            case "SW71": return 105 // MINI Cooper SD (LCI)
                
            // R57 MINI Cabrio (2009)
            case "MR31": return 88  // MINI Cooper Cabrio
            case "MR91": return 155 // MINI John Cooper Works Cabrio
            case "MS31": return 128 // MINI Cooper S Cabrio
            case "XF31": return 82  // MINI Cooper D Cabrio
            case "MS91": return 155 // MINI John Cooper Works Cabrio
            case "ZM31": return 72  // MINI One Cabrio (LCI)
            case "ZN31": return 90  // MINI Cooper Cabrio (LCI)
            case "ZP31": return 135 // MINI Cooper S Cabrio (LCI)
            case "ZP91": return 155 // MINI John Cooper Works Cabrio (LCI)
            case "ZR31": return 82  // MINI Cooper D Cabrio (LCI)
            case "ZR71": return 105 // MINI Cooper SD Cabrio (LCI)
                
            // R58 MINI Coupé (2011)
            case "SX11": return 90  // MINI Cooper Coupé
            case "SX31": return 135 // MINI Cooper S Coupé
            case "SX51": return 155 // MINI John Cooper Works Coupé
            case "SX71": return 105 // MINI Cooper SD Coupé
            case "SX91": return 155 // MINI John Cooper Works Coupé
                
            // R59 MINI Roadster (2012)
            case "SY11": return 90  // MINI Cooper Roadster
            case "SY31": return 135 // MINI Cooper S Roadster
            case "SY51": return 155 // MINI John Cooper Works Roadster
            case "SY71": return 105 // MINI Cooper SD Roadster
            case "SY91": return 155 // MINI John Cooper Works Roadster
                
            // R60 MINI Countryman (2010)
            case "XD11": return 160 // MINI John Cooper Works Countryman
            case "XD31": return 82  // MINI Cooper D Countryman
            case "XD51": return 82  // MINI Cooper D ALL4 Countryman
            case "XD71": return 90  // MINI Cooper ALL4 Countryman
            case "ZA31": return 72  // MINI One Countryman
            case "ZB31": return 90  // MINI Cooper Countryman
            case "ZB51": return 90  // MINI Cooper ALL4 Countryman
            case "ZB71": return 105 // MINI Cooper SD Countryman
            case "ZC31": return 135 // MINI Cooper S Countryman
            case "ZC51": return 135 // MINI Cooper S ALL4 Countryman
            case "ZD11": return 66  // MINI One D Countryman
            case "ZD31": return 82  // MINI Cooper D Countryman
            case "ZD51": return 82  // MINI Cooper D ALL4 Countryman
            case "ZD71": return 105 // MINI Cooper SD ALL4 Countryman
                
            // R61 MINI Paceman (2013)
            case "RJ51": return 82  // MINI Cooper D Paceman
            case "RJ71": return 90  // MINI Cooper ALL4 Paceman
            case "RS11": return 82  // MINI Cooper D Paceman
            case "RS31": return 82  // MINI Cooper D ALL4 Paceman
            case "RS51": return 82  // MINI Cooper D ALL4 Paceman
            case "RS71": return 105 // MINI Cooper SD Paceman
            case "RS91": return 105 // MINI Cooper SD ALL4 Paceman
            case "SS11": return 90  // MINI Cooper Paceman
            case "SS31": return 90  // MINI Cooper ALL4 Paceman
            case "SS51": return 135 // MINI Cooper S Paceman
            case "SS71": return 135 // MINI Cooper S ALL4 Paceman
            case "SS91": return 160 // MINI John Cooper Works Paceman
                
            // Unknown
            default: return 0
                
            }
            
        } else if self.make == .smart || self.make == .mercedes {
            
            switch self.engineID {
                
            // Smart
            case "00": return 30  // Diesel
            case "30": return 37  // Petrol
            case "32": return 45  // Petrol
            case "33": return 35  // Petrol
            case "34": return 60  // Petrol
            case "35": return 40  // Petrol
                //            case "42": return  // TODO: Decoding for current smart models
                
            // Mercedes
            case "12": return 80  // Diesel
            case "43": return 115 // Petrol
                // TODO: Decoding for more Mercedes-Benz models
                
            // Unknown Engine Code in VIN
            default: return 0
            
            }
            
        } else {
            
            return 0
            
        }
        
    }
    
    var hp: Int {
        let kW = self.kW
        return kW.inHP()
    }
    
    var hasHiFiSystem: Bool {
        
        switch self {
            
        case "WBY1Z21050V309243",
             "WBY1Z21080V309141",
             "WBY1Z21090V309164",
             "WBY1Z210X0V309271",
             "WMWXN310103A75532", // M-DX7837
             "WMWXN310103A75773", // M-DX5217
             "WMWXN310203A75636", // M-DX7992
             "WMWXN310703A75759", // M-DX7812
             "WMWXN310803A75771", // M-DX7868
             "WMWXN31030T912195", // M-DX7867
             "WMWXM710002B89893", // M-DX7948
             "WMWXM710102B90390", // M-DX5137
             "WMWXM710102B90440", // M-DX5214
             "WMWXM710103B23606", // M-DX8802
             "WMWXM710202B89894", // M-DX7949
             "WMWXM710302B90438", // M-DX5215
             "WMWXM710502B90991", // M-DX8666
             "WMWXM710602B91020", // M-DX8840
             "WMWXM710702B89941", // M-DX8708
             "WMWXM710703B20578", // M-DX7866
             "WMWXM710803B20184", // M-DX7951
             "WMWXM710803B20234", // M-DX9723
             "WMWXM710902B89892": // M-DX7952
            return true
        default:
            return false
            
        }
        
    }
    
    var isConvertible: Bool {
        
        if self.make == .bmw || self.make == .mini {
            
            switch self.modelID {
                
            case "UL51", "UL91", "UM11", "UM31", "UM51", "UM71", "UM91", "UN71", "UN91", "UP11": return true            // E88 BMW 1er Cabrio (2008)
            case "1K51", "1L71", "1M11", "1M31", "1M51", "2L51", "2L71", "2L91": return true                            // F23 BMW 2er Cabrio (2014)
            case "WG11", "WG31", "WG51", "WG71", "WH31", "WH51", "WH91": return true                                    // F57 MINI Cabrio (2016)
            case "RD31", "RF31", "RH31": return true                                                                    // R52 MINI Cabrio (2004)
            case "MR31", "MR91", "MS31", "XF31", "MS91", "ZM31", "ZN31", "ZP31", "ZP91", "ZR31", "ZR71": return true    // R57 MINI Cabrio (2009)
            case "SY11", "SY31", "SY51", "SY71", "SY91": return true                                                    // R59 MINI Roadster (2012)
            default: return false
                
            }
            
        } else if self.make == .smart {
            
            return self.modelID[3] == "4" ? true : false // a smart is only a convertible or roadster, if the 4th digit of its model ID is a 4
            
        } else if self.make == .mercedes {
            
            // TODO: Add convertible informations for Mercedes-Benz vehicles
            return false
            
        } else {
            
            return false
            
        }
        
    }
    
    var doors: Int {
        return model.doors
    }
    
    var seats: Int {
        return model.seats
    }
    
}
