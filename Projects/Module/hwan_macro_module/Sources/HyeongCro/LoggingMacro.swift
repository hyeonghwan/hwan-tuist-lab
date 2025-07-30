//
//  File.swift
//  HwanMacros
//
//  Created by hwan on 7/22/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftDiagnostics

enum HwanDiagnostic: String, DiagnosticMessage {
    case notNominal
    
    var diagnosticID: MessageID {
        MessageID(domain: "hwan_macros", id: self.rawValue)
    }
    var message: String {
        switch self {
        case .notNominal:
            "can only be applied to a class, struct or actor"
        }
    }
    var severity: DiagnosticSeverity { .error }
}

public struct LoggingMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let allowTypes: [SyntaxKind] = [
          .classDecl,
          .structDecl,
          .actorDecl,
        ]

        guard allowTypes.contains(declaration.kind) else {
            let diagnostic = Diagnostic(
                node: Syntax(node),
                message: HwanDiagnostic.notNominal
            )
            context.diagnose(diagnostic)
            return []
        }

        return [
          DeclSyntax(
            #"""
            lazy var logger: Logger = {
                LoggingMacroHelper.generate(category: String(describing: Self.self))
            }()
            """#),
        ]
    }
}
