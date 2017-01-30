//
//  ColorfulDebug.swift
//  it-e TimeTrack
//
//  Created by Benno Kress on 22.01.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation
import SwifterSwift

class Debug {

    public static var consoleWidth: Int = 202

    static public func print(_ message: DebugPrintMessage) {
        message.printToConsole(fullWidth: consoleWidth)
    }

}

enum DebugPrintMessage {

    case success(source: DebugSource, message: String)
    case warning(source: DebugSource, message: String)
    case error(source: DebugSource, message: String)
    case info(source: DebugSource, message: String)
    case text(source: DebugSource, message: String)
    case event(source: DebugSource, description: String)
    case list(item: String, indent: Int)
    case line
    case space

    public func printToConsole(fullWidth: Int) {

        if case .event = self {
            // Events get a line above the actual output for better visual detection
            DebugPrintMessage.line.printToConsole(fullWidth: fullWidth)
        }

        var leftColumn: String {

            let content: ColumnStyle

            switch self {
            case .line:
                content = .line(columnWidth: columnWidth(for: fullWidth).left)
            case .space:
                content = .blank(columnWidth: columnWidth(for: fullWidth).left)
            case .event:
                content = .alignLeft(message: leftColumnContent, columnWidth: columnWidth(for: fullWidth).left)
            default:
                content = .alignRight(message: leftColumnContent, columnWidth: columnWidth(for: fullWidth).left)
            }

            return content.styledMessage

        }

        let middleColumn = emoji

        var rightColumn: String {

            let content: ColumnStyle

            switch self {
            case .line:
                content = .line(columnWidth: columnWidth(for: fullWidth).right)
            case .space:
                content = .blank(columnWidth: columnWidth(for: fullWidth).right)
            case .event:
                content = .alignRight(message: rightColumnContent, columnWidth: columnWidth(for: fullWidth).right)
            default:
                content = .alignLeft(message: rightColumnContent, columnWidth: columnWidth(for: fullWidth).right)
            }

            return content.styledMessage

        }

        print(leftColumn + middleColumn + rightColumn)
    }

    private var emoji: String {
        switch self {
        case .success: return " ✅ "
        case .warning: return " ⚠️ "
        case .error: return " 🆘 "
        case .info: return " ℹ️ "
        case .line: return "----"
        default: return "    "
        }
    }

    private func columnWidth(for fullWidth: Int) -> (left: Int, middle: Int, right: Int) {
        let emojiWidth = 4
        let leftColumnWidth = (fullWidth - emojiWidth) / 3
        let rightColumnWidth = leftColumnWidth * 2
        return (left: leftColumnWidth, middle: emojiWidth, right: rightColumnWidth)
    }

    private var leftColumnContent: String {
        switch self {
        case .success(let source, _), .warning(let source, _), .error(let source, _), .info(let source, _), .text(let source, _):
            return source.description
        case .event:
            return "Event detected"
        default:
            return ""
        }
    }

    enum ColumnStyle {
        case alignRight(message: String, columnWidth: Int)
        case alignLeft(message: String, columnWidth: Int)
        case line(columnWidth: Int)
        case blank(columnWidth: Int)

        var styledMessage: String {
            switch self {
            case .alignRight(let message, let columnWidth):
                let whitespaceCount = (columnWidth - message.characters.count > 0) ? (columnWidth - message.characters.count) : 0
                return message.prefixed(with: " " * whitespaceCount)
            case .alignLeft(let message, let columnWidth):
                let whitespaceCount = (columnWidth - message.characters.count > 0) ? (columnWidth - message.characters.count) : 0
                return message.followed(by: " " * whitespaceCount)
            case .line(let columnWidth):
                return String(repeating: "-", count: columnWidth)
            case .blank(let columnWidth):
                return String(repeating: " ", count: columnWidth)
            }
        }
    }

    private var rightColumnContent: String {
        switch self {
        case .success(_, let message), .warning(_, let message), .error(_, let message), .info(_, let message), .text(_, let message):
            return message
        case .event(let source, let message):
            let prefix = "↓ "
            let separator = " - "
            return prefix + (source.description.characters.count > 0 ? (source.description + separator) : "") + message
        case .list(let item, let indentAmount):
            var bullet: String {
                if indentAmount == 0 {
                    return "⬜️ "
                } else if indentAmount == 1 {
                    return "◻️ "
                } else if indentAmount == 2 {
                    return "◽️ "
                } else if indentAmount == 3 {
                    return "▫️ "
                } else {
                    return "   "
                }
            }
            return item.prefixed(with: bullet).indented(by: indentAmount)
        default:
            return ""
        }
    }

}

enum DebugSource: CustomStringConvertible {

    case location(_: Source)
    case function(_: String, of: String)
    case view(_: View)
    case custom(name: String)
    case irrelevant

    var description: String {
        switch self {
        case .location(let source):
            return "\(source)"
        case .function(let functionName, let className):
            let functionIdentifier = "\(className).\(functionName.until("("))"
            return functionIdentifier.surrounded(by: "[", and: "]")
        case .view(let view):
            return "\(view.viewName)"
        case .custom(let viewName):
            return viewName
        case .irrelevant:
            return ""
        }
    }

}

struct Source: CustomStringConvertible {
    init(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        self.file = file
        self.line = line
        self.column = column
        self.function = function
    }

    public let file: String
    public let line: Int
    public let column: Int
    public let function: String

    public var description: String {
        let functionName = function.until("(")
        if let className = file.splitted(by: "/").last?.splitted(by: ".").first {
            return "[\(className).\(functionName)]"
        } else {
            return "[\(functionName)]"
        }
    }
}
