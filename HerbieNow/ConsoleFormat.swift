//
//  ConsoleFormat.swift
//  HerbieNow
//
//  Created by Benno Kress on 30.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation

enum ConsoleFormat {
    case success(class: Any, func: String, message: String)
    case warning(class: Any, func: String, message: String)
    case error(class: Any, func: String, message: String)
    case info(class: Any, func: String, message: String)
    case event(message: String)
    case list(message: String, indent: Int)
    case line
    case space
}

extension ConsoleFormat: CustomStringConvertible {

    /// Adjust this width by 1 to get the whole width on the console adjusted by 3.
    var leftColumnWidth: Int {
        return 66
    }

    var description: String {
        switch self {
        case .success(let classObject, let funcName, let message):
            return "\(getSourceTag(for: funcID(class: classObject, func: funcName))) ✅ \(message)"
        case .warning(let classObject, let funcName, let message):
            return "\(getSourceTag(for: funcID(class: classObject, func: funcName))) ⚠️ \(message)"
        case .error(let classObject, let funcName, let message):
            return "\(getSourceTag(for: funcID(class: classObject, func: funcName))) 🆘 \(message)"
        case .info(let classObject, let funcName, let message):
            return "\(getSourceTag(for: funcID(class: classObject, func: funcName))) ℹ️ \(message)"
        case .event(let message):
            let headline = "Event detected"
            let headlineWidth = headline.characters.count
            let line = "\(String(repeating: "-", count: fullWidth))\n"
            let left = "\(headline)\(String(repeating: " ", count: leftColumnWidth - headlineWidth))"
            let middle = String(repeating: " ", count: middleColumnWidth)
            let right = rightAligned(message)
            return "\(line)\(left)\(middle)\(right)"
        case .list(let message, let indent):
            var bullet: String
            switch indent {
            case 0:
                bullet = ""
            case 1:
                bullet = "◽️"
            default:
                bullet = "▫️"
            }
            let bulletedMessage = "\(bullet)  \(message)".indent(tabs: indent)
            return "\(emptyLeftAndMiddleColumn())\(bulletedMessage)"
        case .line:
            return String(repeating: "-", count: fullWidth)
        case .space:
            return ""
        }
    }

    var rightColumnWidth: Int {
        return 2 * leftColumnWidth
    }

    var middleColumnWidth: Int {
        return 4
    }

    var fullWidth: Int {
        return leftColumnWidth + middleColumnWidth + rightColumnWidth
    }

    func rightAligned(_ message: String) -> String {
        let fullMessage = "↓ \(message)"
        let whitespaceLength = rightColumnWidth - fullMessage.characters.count
        let spaces = whitespaceLength > 0 ? String(repeating: " ", count: whitespaceLength) : ""
        return fullMessage.prefixed(with: spaces)
    }

    func getSourceTag(for source: String) -> String {
        let sourceLength = source.characters.count
        let whitespaceLength = leftColumnWidth - sourceLength
        let spaces = whitespaceLength > 0 ? String(repeating: " ", count: whitespaceLength) : ""
        return "[\(source)]".prefixed(with: spaces)
    }

    func emptyLeftAndMiddleColumn() -> String {
        return String(repeating: " ", count: leftColumnWidth + middleColumnWidth)
    }

}
