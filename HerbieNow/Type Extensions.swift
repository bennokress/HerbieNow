//
//  TypeExtensions.swift
//  HerbieNow
//
//  Created by Benno Kress on 14.12.16.
//  Copyright © 2017 LMU. All rights reserved.
//

import UIKit
import JASON
import Alamofire

extension Bool {

    func toInt() -> Int {
        return self ? 1 : 0
    }

}

extension DataRequest {

    /**
     Creates a response serializer that returns a JASON.JSON object constructed from the response data.

     - returns: A JASON.JSON object response serializer.
     */
    static public func JASONReponseSerializer() -> DataResponseSerializer<JASON.JSON> {
        return DataResponseSerializer { _, _, data, error in
            if let error = error {
                return .failure(error)
            } else {
                return .success(JASON.JSON(data))
            }
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

extension Date {

    func toString(withWords: Bool = true) -> String {
        if withWords && self.isInToday {
            return "Today"
        } else if withWords && self.isInYesterday {
            return "Yesterday"
        } else {
            return self.customDateString
        }
    }

    func subtracting(_ component: Calendar.Component, value: Int) -> Date {
        return self.adding(component, value: -1*value)
    }

    var timeDescription: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        return "\(hour):\(minutes)"
    }

    // MARK: - Private Date Helpers

    private func isInSameDay(as dateToCompare: Date) -> Bool {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self) == df.string(from: dateToCompare)
    }

    private var isInYesterday: Bool {
        return self.adding(.day, value: 1).isInToday
    }

    private var customDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "MMMM d"
        return "\(dateFormatter.string(from: self))\(self.daySuffix)"
    }

    private var daySuffix: String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }

}

extension Dictionary {

    func appending(_ value: Value, forKey key: Key) -> [Key: Value] {
        var result = self
        result[key] = value
        return result
    }

}

extension Double {

    func inPercent() -> Int {
        // TODO: Rounds wrong!?!? -> 0.58 is 57
        return Int(self * 100)
    }
}

extension Int {

    /// Converts 1 to true and 0 to false. Defaults to false.
    func toBool() -> Bool {
        switch self {
        case 1:
            return true
        default:
            return false
        }
    }

    func toString() -> String {
        return "\(self)"
    }

    /// Converts Integer to 3-digit-String
    func to3DigitString() -> String {
        if self >= 0 && self < 10 {
            return "00\(self)"
        } else if self >= 10 && self < 100 {
            return "0\(self)"
        } else if self >= 100 && self < 1000 {
            return "\(self)"
        } else {
            return "999"
        }
    }

}

extension JSON {

    /// The value as a Character or nil if not present/convertible
    public var character: Character? { return stringValue.characters.first }

}

extension String {

    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? nil

    }

    func prefixed(with prefix: String) -> String {
        return "\(prefix)\(self)"
    }

    func indent(tabs: Int) -> String {
        let spaces = String(repeating: " ", count: 4*tabs)
        return self.prefixed(with: spaces)
    }

    private func replacing(_ string: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement)
    }

    mutating func removeWhitespace() {
        self = self.replacing(" ", with: "")
    }

    func replaceGermanCharacters() -> String {

        return self
            .replacing("ä", with: "ae")
            .replacing("ö", with: "oe")
            .replacing("ü", with: "ue")
            .replacing("Ä", with: "Ae")
            .replacing("Ö", with: "Oe")
            .replacing("Ü", with: "Ue")
            .replacing("ß", with: "ss")

    }

    func until(_ string: String) -> String {
        var components = self.components(separatedBy: string)
        return components[0]
    }

    func toBoolArray() -> [Bool] {
        var boolArray:[Bool] = []
        for char in self.characters {
            if char == "0" {
                boolArray.append(false)
            } else {
                boolArray.append(true)
            }
        }
        return boolArray

    }

    func toIntArray() -> [Int] {

        let index = self.index(self.startIndex, offsetBy: 3)
        guard let min = Int(self.substring(to: index)), let max = Int(self.substring(from: index)) else {
            return []
        }

        // converting a 6-digit string of the form 065090 into an Int-array of the form [65, 90]
        var intArray:[Int] = []

        intArray.append(min)
        intArray.append(max)

        return intArray
    }

    struct Numbers { static let characterSet = CharacterSet(charactersIn: "0123456789") }

    var numbers: String { return components(separatedBy: Numbers.characterSet.inverted).joined() }
    var integer: Int { return Int(numbers) ?? 0 }

}

extension UITextField {

    func clear() {
        DispatchQueue.main.async {
            self.text = ""
        }
    }

}

extension UIColor {

    convenience init(html htmlString: String) {
        let htmlString: String = htmlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: htmlString)

        if htmlString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:1)
    }

}
