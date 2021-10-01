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

var options = Options.parseOrExit()

let dir = options.dir ?? NSTemporaryDirectory() + "kr-calc"
let storage: krCalcLib.Storage

do {
    storage = try Storage(dir: dir)
} catch {
    fatalError(error.localizedDescription)
}

let app = Calculator(storage: storage)

app.saveResult = true
app.field = options.field
app.levelUpperBound = options.levelUpperBound
app.logLevel = options.logLevel

let name = options.name ?? {
    for i in 0 ... Int.max {
        let name = "result-\(i)"
        if !storage.exists(name) {
            return name
        }
    }
    exit(1)
}()

var K: Link

if let braid = options.braid {
    app.useSymmetry = true
    K = Braid<anySize>(code: braid).closure
} else if let pdCode = options.pdCode {
    app.useSymmetry = false
    K = Link(pdCode: pdCode)
} else {
    exit(1)
}

if options.mirror {
    K = K.mirrored
}

if K.components.count > 1 {
    app.useSymmetry = false
}

let result = app.compute(name, K)

print()
print(result.toString(format: options.format))
