//
//  File.swift
//
//
//  Created by Taketo Sano on 2021/06/28.
//

import Foundation
import SwmCore
import SwmKnots
import SwmKR
import krCalcLib

let options = Options.parseOrExit()

let dir = options.dir ?? NSTemporaryDirectory() + "kr-calc"
let storage: krCalcLib.Storage

do {
    storage = try Storage(dir: dir)
} catch {
    fatalError(error.localizedDescription)
}

let app = Calculator(storage: storage)

app.field = options.field
app.logLevel = options.logLevel

let name = options.name ?? { () -> String in
    options.braid.map{ String($0) }.joined(separator: ",")
}()

let result = app.compute(name, options.braid)

print()
print(result.toString(format: options.format))
