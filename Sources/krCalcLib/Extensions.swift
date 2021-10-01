//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/08/16.
//

import SwmCore
import SwmMatrixTools
import SwmHomology
import SwmEigen
import SwmxBigInt

extension RationalNumber: HomologyCalculatable {
    public static func homologyCalculator<C>(forChainComplex c: C, options: HomologyCalculatorOptions) -> HomologyCalculator<C>
    where C.BaseModule.BaseRing == Self {
        LUHomologyCalculator<C, EigenSparseMatrixImpl<Self>>(chainComplex: c, options: options)
    }
}

extension BigRational: ComputationalRing {
    public var computationalWeight: Double {
        isZero ? 0 : Double(max(numerator.abs, denominator))
    }
}

extension BigRational: HomologyCalculatable{
    public static func homologyCalculator<C>(forChainComplex c: C, options: HomologyCalculatorOptions) -> HomologyCalculator<C>
    where C.BaseModule.BaseRing == Self {
        LUHomologyCalculator<C, DefaultSparseMatrixImpl<Self>>(chainComplex: c, options: options)
    }
}

extension F2: HomologyCalculatable {
    public static func homologyCalculator<C>(forChainComplex c: C, options: HomologyCalculatorOptions) -> HomologyCalculator<C>
    where C.BaseModule.BaseRing == Self {
        LUHomologyCalculator<C, EigenSparseMatrixImpl<Self>>(chainComplex: c, options: options)
    }
}
