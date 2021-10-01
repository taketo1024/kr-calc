//
//  File.swift
//
//
//  Created by Taketo Sano on 2021/06/28.
//

import Foundation
import SwmCore
import SwmHomology
import SwmKnots
import SwmKR
import SwmxBigInt

public final class Calculator {
    public enum Field: String {
        case Q, QQ
    }

    public let storage: Storage
    
    public var field: Field = .Q
    public var useSymmetry = true
    public var levelUpperBound: Int? = nil
    public var saveResult = false
    public var saveProgress = false
    public var logLevel = 0
    
    public init(storage: Storage) {
        self.storage = storage
    }

    @discardableResult
    public func compute(_ name: String, _ b: Braid<anySize>) -> Result {
        compute(name, b.closure)
    }

    @discardableResult
    public func compute(_ name: String, _ K: Link) -> Result {
        log("target: \(name)")
        log("field: \(field)")
        log("symmetry: \(useSymmetry)")

        let start = Date()
        let result = { () -> Result in
            switch field {
            case .Q : return _compute(name, K, RationalNumber.self)
            case .QQ: return _compute(name, K, BigRational.self)
            }
        }()
        
        log("time: \(time(since: start))")

        if saveResult {
            storage.save(name, result)
            log("saved: \(storage.absolutePath(name))")
        }
        
        return result
    }
    
    private func _compute<R: HomologyCalculatable>(_ target: String, _ K: Link, _ type: R.Type) -> Result {
        if useSymmetry && K.writhe > 0 {
            log("compute from mirror.", level: 2)
            return _compute("m\(target)", K.mirrored, type).mirror
        }
        
        var result: Result = [:]
        
        let H = KRHomology<R>(K, symmetry: useSymmetry)
        let n = K.crossingNumber
        let w = K.writhe
        let r = K.numberOfSeifertCircles
        
        let levelRange = (useSymmetry && levelUpperBound == nil)
            ? H.levelRange
            : (-2 * n ... (levelUpperBound ?? -n))
        
        log("\nn = \(n)", level: 2)
        log("w = \(w)", level: 2)
        log("r = \(r)\n", level: 2)
        
        log("level-range: \(levelRange)\n", level: 2)
        
        if useSymmetry {
            log("i: \(H.iRange)", level: 2)
            log("j: \(H.jRange)", level: 2)
            log("k: \(H.kRange)\n", level: 2)
        }
        
        let tmpFile = "tmp-\(target)"
        if saveProgress, let tmp = storage.load(tmpFile) {
            result = tmp
            log("continue from:\n\(result.toString(format: .table)))\n", level: 3)
        }
        
        for s in levelRange {
            log("level: \(s)", level: 3)
            
            for v in 0 ... n {
                for h in 0 ... n {
                    let (i, j, k) = H.hvs2ijk(h, v, s)
                    
                    if result[[i, j, k]] != nil {
                        continue
                    }
                    
                    if useSymmetry && (i > 0
                        || !H.iRange.contains(i)
                        || !H.jRange.contains(j)
                        || !H.kRange.contains(k + 2 * i)
                    )
                    {
                        continue
                    }
                    
                    log("\tH\([i, j, k]) =", level: 3)
                    
                    let d = H[i, j, k].rank
                    
                    log("\t\t\(d)", level: 3)
                    
                    result[[i, j, k]] = d
                    
                    if useSymmetry && i < 0 {
                        result[[-i, j, k + 2 * i]] = d
                    }
                    
                    if saveProgress {
                        storage.save(tmpFile, result)
                    }
                }
            }
            H.clearCache()
        }
        
        log("", level: 3)

        result = result.exclude{ (_, d) in d == 0 }
        
        if saveProgress {
            storage.delete(tmpFile)
        }

        return result
    }
    
    private func time(since: Date) -> String {
        let dec = 1000.0
        let time = Date().timeIntervalSince(since)
        return (time < 1)
            ? "\(round(time * dec * 1000) / dec) msec."
            : "\(round(time * dec) / dec) sec."
    }
    
    private func log(_ msg: @autoclosure () -> String, level: Int = 1) {
        if logLevel >= level {
            print(msg())
        }
    }
}
