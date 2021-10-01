//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/09/17.
//

import Foundation
import ArgumentParser
import SwmCore
import SwmKnots
import krCalcLib

extension Calculator.Field: ExpressibleByArgument {}
extension ResultFormat: ExpressibleByArgument {}

struct Options: ParsableArguments {
    @Option(
        name: .short,
        help: ArgumentHelp("name of target, e.g. 3_1", valueName: "name")
    )
    var name: String?

    @Option(
        name: .short,
        help: ArgumentHelp("input braid, e.g. [1,1,1]", valueName: "braid")
    )
    var braidString: String?

    lazy var braid: [Int]? = {
        if let braidString = braidString {
            return try? JSONDecoder().decode([Int].self, from: braidString.data(using: .utf8)!)
        } else {
            return nil
        }
    }()

    @Option(
        name: [.customShort("x")],
        help: ArgumentHelp("input PD-code, e.g. [[1,5,2,4],[3,1,4,6],[5,3,6,2]]", valueName: "pd-code")
    )
    var pdCodeString: String?

    lazy var pdCode: [[Int]]? = {
        if let pdCodeString = pdCodeString {
            return try? JSONDecoder().decode([[Int]].self, from: pdCodeString.data(using: .utf8)!)
        } else {
            return nil
        }
    }()

    @Flag(
        name: .short,
        help: ArgumentHelp("mirror")
    )
    var mirror: Bool = false
    
    @Option(
        name: .customShort("F"),
        help: ArgumentHelp("field: {Q, QQ}", valueName: "field")
    )
    var field: Calculator.Field = .Q
    
    @Option(
        name: .customShort("u"),
        help: ArgumentHelp("level upper bound (default: -n)", valueName: "int")
    )
    var levelUpperBound: Int?
    
    @Option(
        name: .customShort("f"),
        help: ArgumentHelp("output format", valueName: "format")
    )
    var format = ResultFormat.table
    
    @Option(
        name: .short,
        help: ArgumentHelp("output directory", valueName: "path")
    )
    var dir: String?
    
    @Option(
        name: .customShort("l"),
        help: ArgumentHelp("log-level", valueName: "level")
    )
    var logLevel = 3
    
    mutating func validate() throws {
        if braidString == nil && pdCodeString == nil {
            throw ValidationError("Either <braid> or <pd-code> must be specified.")
        }
        
        if braidString != nil && braid == nil {
            throw ValidationError("Could not parse <braid>: '\(braidString!)'.")
        }
        
        if pdCodeString != nil && pdCode == nil {
            throw ValidationError("Could not parse <pd-code>: '\(pdCodeString!)'.")
        }
        
        if let pdCode = pdCode {
            if !pdCode.allSatisfy({ $0.count == 4 }) {
                throw ValidationError("Invalid <pd-code>: '\(pdCodeString!)'.")
            }
        }
    }
}
