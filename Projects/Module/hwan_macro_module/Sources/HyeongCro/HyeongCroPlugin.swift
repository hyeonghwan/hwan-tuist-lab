
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct HyeongCroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        LoggingMacro.self
    ]
}

// mkdir MyMacro && cd MyMacro
// swift package init --type macro
