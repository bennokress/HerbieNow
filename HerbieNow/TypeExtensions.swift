//
//  TypeExtensions.swift
//  HerbieNow
//
//  Created by Benno Kress on 14.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import JASON
import Alamofire

extension DataRequest {

    /**
     Creates a response serializer that returns a JASON.JSON object constructed from the response data.

     - returns: A JASON.JSON object response serializer.
     */
    static public func JASONReponseSerializer() -> DataResponseSerializer<JASON.JSON> {
        return DataResponseSerializer { _, _, data, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                return .failure(error!)
            }

            return .success(JASON.JSON(data))
        }
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter completionHandler: A closure to be executed once the request has finished.

     - returns: The request.
     */
    @discardableResult
    public func responseJASON(completionHandler: @escaping (DataResponse<JASON.JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.JASONReponseSerializer(), completionHandler: completionHandler)
    }

}

extension Dictionary {

    func appending(_ value: Value, forKey key: Key) -> [Key: Value] {
        var result = self
        result[key] = value
        return result
    }

}

extension Int {
    
    // kW to horse power conversion
    func inHP() -> Int {
        return Int(Double(self) * 1.35962)
    }
    
}

extension String {

    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? nil

    }
    
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
    
    private var makeID: String {
        return self[0...2] // The first 3 characters of the vehicle identification number are its manufacturer
    }
    
    private var smartEngineID: String {
        return self[7...8] // Smart have their engine information at character 8 and 9 of the vehicle identification number
    }
    
    var make: String {
        
        switch self.makeID {
        case "WBA": return "BMW"
        case "WBS": return "BMW"
        case "WBY": return "BMW"
        case "WDB": return "Mercedes-Benz"
        case "WDC": return "Mercedes-Benz"
        case "WDD": return "Mercedes-Benz"
        case "WME": return "smart"
        case "WMW": return "MINI"
        default:
            return "Unknown"
        }
        
    }
    
    var model: String {
        
        if self.makeID == "BMW" || self.makeID == "MINI" {
        
            switch self.modelID {
                
            case "LN31", "LN51", "LN71", "LN91", "LR51", "LR71", "LR91", "LU31", "LU71", "LU91": return "Clubman"                                                                   // F54
            case "XS11", "XS51", "XS71", "XS91", "XT11", "XT31", "XT71", "XT91", "XU11", "XU31": return "5 Door"                                                                    // F55
            case "XM51", "XM71", "XM91", "XN11", "XN31", "XN71", "XN91", "XP11", "XP51", "XP51": return "3 Door"                                                                    // F56
            case "WG11", "WG31", "WG51", "WG71", "WH31", "WH51", "WH91": return "Cabrio"                                                                                            // F57
                                                                                                                                                                                    // F60
            case "1Z21", "1Z41": return "i3"                                                                                                                                        // I01
            case "RA11", "RA31", "RB11", "RC31": return "3 Door"                                                                                                                    // R50
            case "RD31", "RF31", "RH31": return "Cabrio"                                                                                                                            // R52
            case "RE31", "RE91": return "3 Door"                                                                                                                                    // R53
            case "MH31", "MH91", "ML31", "MM31", "MM91", "MN51", "XE51", "ZE31", "ZF31", "ZG31", "ZG91", "ZH11", "ZH51", "ZH71": return "Clubman"                                   // R55
            case "ME31", "MF31", "MF71", "MF91", "MG31", "MG51", "SR11", "SR31", "SR51", "SR81", "SU31", "SU91", "SV31", "SV91", "SW11", "SW31", "SW51", "SW71": return "3 Door"    // R56
            case "MR31", "MR91", "MS31", "XF31", "MS91", "ZM31", "ZN31", "ZP31", "ZP91", "ZR31", "ZR71": return "Cabrio"                                                            // R57
            case "SX11", "SX31", "SX51", "SX71", "SX91": return "Coupé"                                                                                                             // R58
            case "XD11", "XD31", "XD51", "XD71", "ZA31", "ZB31", "ZB51", "ZB71", "ZC31", "ZC51", "ZD11", "ZD31", "ZD51", "ZD71": return "Countryman"                                // R60
            case "RJ51", "RJ71", "RS11", "RS31", "RS51", "RS71", "RS91", "SS11", "SS31", "SS51", "SS71", "SS91": return "Paceman"                                                   // R61
            default: return "Model" // Unknown BMW or MINI
                
            }
            
        } else if self.makeID == "smart" {
            
            switch self.modelID {
                
            case "4503", "4504", "4513", "4514": return "fortwo"
            case "4523", "4524": return "roadster"
            case "4533", "4534": return "forfour"
            default: return "Model" // Unknown Smart
                
            }
            
        } else if self.makeID == "Mercedes-Benz" {
            
            // TODO: Add Mercedes-Benz Models
            return "Model" // Unknown Mercedes-Benz
            
        } else {
            
            return "Model" // Completely unknown vehicle
            
        }
        
    }
    
    var kW: Int {
        
        if self.makeID == "BMW" || self.makeID == "MINI" {
        
            switch self.modelID {
                
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
        
        } else if self.makeID == "smart" {
            
            switch self.smartEngineID {
            case "00": return 30 // Diesel
            case "30": return 37 // Petrol
            case "32": return 45 // Petrol
            case "33": return 35 // Petrol
            case "34": return 60 // Petrol
            case "35": return 40 // Petrol
                
            // Unknown Engine Code in VIN
            default: return 0
                
            }
                
        } else if self.makeID == "Mercedes-Benz" {
            
            // TODO: Add kW informations for Mercedes-Benz vehicles
            return 0
            
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
        
        if self.makeID == "BMW" || self.makeID == "MINI" {
        
            switch self.modelID {
                
            case "WG11", "WG31", "WG51", "WG71", "WH31", "WH51", "WH91": return true                                    // F57 MINI Cabrio (2016)
            case "RD31", "RF31", "RH31": return true                                                                    // R52 MINI Cabrio (2004)
            case "MR31", "MR91", "MS31", "XF31", "MS91", "ZM31", "ZN31", "ZP31", "ZP91", "ZR31", "ZR71": return true    // R57 MINI Cabrio (2009)
            case "SY11", "SY31", "SY51", "SY71", "SY91": return true                                                    // R59 MINI Roadster (2012)
            default: return false
                
            }
        
        } else if self.makeID == "smart" {
            
            return self.modelID[3] == "4" ? true : false // a smart is only a convertible or roadster, if the 4th digit of its model ID is a 4
            
        } else if self.makeID == "Mercedes-Benz" {
            
            // TODO: Add convertible informations for Mercedes-Benz vehicles
            return false
            
        } else {
            
            return false
            
        }
        
    }

}
