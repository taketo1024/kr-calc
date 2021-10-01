import XCTest
import Foundation
import SwmCore

@testable import krCalcLib

final class CalculatorTests: XCTestCase {
    func calculator(field: Calculator.Field = .Q) -> Calculator {
        let dir = NSTemporaryDirectory() + "kr-calc-tests"
        let storage = try! Storage(dir: dir)
        
        let calc = Calculator(storage: storage)
        calc.logLevel = 0
        calc.saveResult = false
        calc.saveProgress = false
        calc.field = field
        
        return calc
    }
    
    func test3_1() {
        let c = calculator()
        let str = c.compute("3_1", [1,1,1])
        XCTAssertEqual(str, [[-2, 2, 2]: 1, [2, 2, -2]: 1, [0, 4, -2]: 1])
    }

    func test3_1_QQ() {
        let c = calculator(field: .QQ)
        let str = c.compute("3_1", [1,1,1])
        XCTAssertEqual(str, [[-2, 2, 2]: 1, [2, 2, -2]: 1, [0, 4, -2]: 1])
    }

    func test4_1() {
        let c = calculator()
        let str = c.compute("4_1", [1,-2,1,-2])
        XCTAssertEqual(str, [[0, 0, 0]: 1, [0, -2, 2]: 1, [2, 0, -2]: 1, [0, 2, -2]: 1, [-2, 0, 2]: 1])
    }

    func test4_1_QQ() {
        let c = calculator(field: .QQ)
        let str = c.compute("4_1", [1,-2,1,-2])
        XCTAssertEqual(str, [[0, 0, 0]: 1, [0, -2, 2]: 1, [2, 0, -2]: 1, [0, 2, -2]: 1, [-2, 0, 2]: 1])
    }

    func test5_1() {
        let c = calculator()
        let str = c.compute("5_1", [1,1,1,1,1])
        XCTAssertEqual(str, [[0, 4, 0]: 1, [2, 6, -4]: 1, [-4, 4, 4]: 1, [4, 4, -4]: 1, [-2, 6, 0]: 1])
    }

    func test5_1_QQ() {
        let c = calculator(field: .QQ)
        let str = c.compute("5_1", [1,1,1,1,1])
        XCTAssertEqual(str, [[0, 4, 0]: 1, [2, 6, -4]: 1, [-4, 4, 4]: 1, [4, 4, -4]: 1, [-2, 6, 0]: 1])
    }

    func test5_2() {
        let c = calculator()
        let str = c.compute("5_2", [1,1,1,2,-1,2])
        XCTAssertEqual(str, [[-2, 2, 2]: 1, [0, 4, -2]: 1, [2, 2, -2]: 1, [0, 2, 0]: 1, [0, 6, -4]: 1, [-2, 4, 0]: 1, [2, 4, -4]: 1])
    }

    func test5_2_QQ() {
        let c = calculator(field: .QQ)
        let str = c.compute("5_2", [1,1,1,2,-1,2])
        XCTAssertEqual(str, [[-2, 2, 2]: 1, [0, 4, -2]: 1, [2, 2, -2]: 1, [0, 2, 0]: 1, [0, 6, -4]: 1, [-2, 4, 0]: 1, [2, 4, -4]: 1])
    }
}
