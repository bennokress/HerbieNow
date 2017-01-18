//
//  ConsoleFormat.swift
//  TimeTrack
//
//  Created by Benno Kress on 23.08.16.
//  Copyright © 2016 it-economics. All rights reserved.
//

import Foundation

enum ConsoleFormat {
    case success(source: (class: String, func: String), message: String)
    case warning(source: (class: String, func: String), message: String)
    case error(source: (class: String, func: String), message: String)
    case info(source: (class: String, func: String), message: String)
    case event(message: String)
    case list(message: String, indent: Int)
    case line
    case space
}

extension ConsoleFormat: CustomStringConvertible {

    /// Adjust this width by 1 to get the whole width on the console adjusted by 3.
    private var leftColumnWidth: Int {
        return 66
    }

    internal var description: String {
        switch self {
        case .success(let source, let message):
            return "\(getSourceTag(for: source.class, source.func)) ✅ \(message)"
        case .warning(let source, let message):
            return "\(getSourceTag(for: source.class, source.func)) ⚠️ \(message)"
        case .error(let source, let message):
            return "\(getSourceTag(for: source.class, source.func)) 🆘 \(message)"
        case .info(let source, let message):
            return "\(getSourceTag(for: source.class, source.func)) ℹ️ \(message)"
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

    private var rightColumnWidth: Int {
        return 2 * leftColumnWidth
    }

    private var middleColumnWidth: Int {
        return 4
    }

    private var fullWidth: Int {
        return leftColumnWidth + middleColumnWidth + rightColumnWidth
    }

    private func rightAligned(_ message: String) -> String {
        let fullMessage = "↓ \(message)"
        let whitespaceLength = rightColumnWidth - fullMessage.characters.count
        let spaces = whitespaceLength > 0 ? String(repeating: " ", count: whitespaceLength) : ""
        return fullMessage.prefixed(with: spaces)
    }

    private func getSourceTag(for className: String, _ functionName: String) -> String {
        let source = "\(className).\(functionName.until("("))"
        let sourceLength = source.characters.count
        let whitespaceLength = leftColumnWidth - sourceLength
        let spaces = whitespaceLength > 0 ? String(repeating: " ", count: whitespaceLength) : ""
        return "[\(source)]".prefixed(with: spaces)
    }

    private func emptyLeftAndMiddleColumn() -> String {
        return String(repeating: " ", count: leftColumnWidth + middleColumnWidth)
    }

}
