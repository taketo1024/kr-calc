//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/09/17.
//

import Foundation
import ArgumentParser
import Regex
import SwmCore
import SwmKR

public enum ResultFormat: String, ExpressibleByArgument {
    case table, polynomial, texTable, texPolynomial
}

public typealias Result = [[Int] : Int]

public extension Dictionary where Key == [Int], Value == Int {
    var mirror: Self {
        mapPairs{ (g, r) in ([-g[0], -g[1], -g[2]], r)}
    }
    
    func asHOMFLYPolynomial() -> KR.qaPolynomial<Int> {
        .init(elements: self.map { (g, r) in
            let (i, j, k) = (g[0], g[1], g[2])
            return ([i, j], (-1).pow( (k - j) / 2) * r )
        }).reduced
    }
    
    func asPoincarePolynomial() -> KR.tqaPolynomial<Int> {
        .init(elements: self.map { (g, r) in
            let (i, j, k) = (g[0], g[1], g[2])
            return ([(k - j) / 2, i, j], r)
        })
    }
    
    func toString(format: ResultFormat = .table) -> String {
        switch format {
        case .table:
            return table()
        case .polynomial:
            return asPoincarePolynomial().description
        case .texTable:
            return texTable()
        case .texPolynomial:
            return texPolynomial()
        }
    }
    
    private func tableData() -> ([IntList<_2> : KR.qPolynomial<Int>], [Int], [Int]) {
        typealias qPoly = KR.qPolynomial<Int>
        let table = self.group { (g, _) in
                IntList<_2>(g[1], g[2])
            }
            .mapValues{ list in
                qPoly(elements: list.map{ (g, r) in
                    (g[0], r)
                })
            }
        
        let js = table.keys.map{ $0[0] }.uniqued().sorted()
        let ks = table.keys.map{ $0[1] }.uniqued().sorted()
        return (table, js, ks)
    }
    
    private func table(showZeros: Bool = false) -> String {
        let (table, js, ks) = tableData()
        return Format.table(
            rows: ks.reversed(),
            cols: js,
            symbol: "k\\j",
            printHeaders: true
        ) { (k, j) -> String in
            if let q = table[[j, k]] {
                return (!q.isZero || showZeros) ? "\(q)" : ""
            } else {
                return ""
            }
        }
    }

    private func texPolynomial() -> String {
        asPoincarePolynomial().elements.sorted{ (e, _) in e }.map { (e, r) -> String in
            let mon = zip(["t", "q", "a"], e).map { (x, i) in
                i == 0 ? "" : "\(x)^{\(i)}"
            }.joined()
            return mon == "" ? "\(r)" : r == 1 ? mon : "\(r)\(mon)"
        }.joined(separator: " + ")
    }
    
    private func texTable() -> String {
        let (table, js, ks) = tableData()
        let body = ks.reversed().map { k -> String in
            "$\(k)$ & " + js.map { j in
                let qpoly = table[[j, k]] ?? .zero
                return qpoly.terms.sorted{ $0.leadExponent }.map { term -> String in
                    let n = term.leadCoeff
                    let i = term.leadExponent
                    let x = i == 0 ? "\(n)" : n == 1 ? "q^{\(i)}" : "\(n)q^{\(i)}"
                    return "$\(x)$"
                }.joined(separator: " + ")
            }.joined(separator: " & ")
        }.joined(separator: " \\\\\n") + " \\\\"
        
        return """
\\begin{tabular}{l|\(Array(repeating: "l", count: js.count).joined())}
$k \\setminus j$ & \(js.map{ j in "$\(j)$" }.joined(separator: " & ")) \\\\
\\hline
\(body)
\\end{tabular}
"""
    }
}
