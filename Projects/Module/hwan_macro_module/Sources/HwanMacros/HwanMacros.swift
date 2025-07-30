// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "HyeongCro", type: "StringifyMacro")


import Foundation
@_exported import OSLog

@attached(member, names: named(logger))
public macro Logging() = #externalMacro(module: "HyeongCro", type: "LoggingMacro")


public enum LoggingMacroHelper {
    public static func generate(_ fileID: String = #fileID, category: String) -> Logger {
        let subsystem = fileID.components(separatedBy: "/").first.map { "kr.hwan.\($0)" }
        return subsystem.map { Logger(subsystem: $0, category: category) }
        ?? Logger()
    }
}
