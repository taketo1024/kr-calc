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

struct Options: ParsableArguments {
    @Option(
        name: [.short],
        help: ArgumentHelp("name of target, e.g. 3_1", valueName: "name")
    )
    var name: String?

    @Option(
        name: [.short],
        help: ArgumentHelp("input braid, e.g. [1,1,1]", valueName: "braid")
    )
    var braidString: String

    @Option(
        name: [.customShort("F")],
        help: ArgumentHelp("field: {Q, QQ}", valueName: "field")
    )
    var field: Calculator.Field = .Q
    
    @Option(
        name: [.customShort("f")],
        help: ArgumentHelp("output format", valueName: "format")
    )
    var format = ResultFormat.table
    
    @Option(
        name: [.short],
        help: ArgumentHelp("output directory", valueName: "path")
    )
    var dir: String?
    
    @Option(
        name: [.short],
        help: ArgumentHelp("log-level", valueName: "level")
    )
    var logLevel = 3
    
    var braid: [Int]! {
        get {
            try? JSONDecoder().decode([Int].self, from: braidString.data(using: .utf8)!)
        }
    }

    func validate() throws {
        guard braid != nil else {
            throw ValidationError("invalid input for <braid>: '\(braidString)'.")
        }
        
        guard Braid<anySize>(code: braid).closure.components.count == 1 else {
            throw ValidationError("closure of <braid> has more than 1 components: '\(braidString)'.")
        }
    }
}
