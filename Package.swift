// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kr-calc",
    dependencies: [
        .package(
            url: "https://github.com/taketo1024/swm-core.git",
            from: "1.3.1"
//            path: "../swm-core/"
        ),
        .package(
            url: "https://github.com/taketo1024/swm-kr.git",
            from: "0.5.1"
//            path: "../swm-kr/"
        ),
        .package(
            url: "https://github.com/taketo1024/swm-eigen.git",
            from: "1.1.0"
//            path: "../swm-eigen/"
        ),
        .package(
            url: "https://github.com/taketo1024/swmx-bigint.git",
            from: "1.0.1"
//            path: "../swmx-bigint/"
        ),
        .package(
            url: "https://github.com/crossroadlabs/Regex.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.0.0"
        ),
//        .package(
//            url: "https://github.com/swiftcsv/SwiftCSV.git",
//            from: "0.6.0"
//        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "kr-calc",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "krCalcLib",
            ]
        ),
        .target(
            name: "krCalcLib",
            dependencies: [
                .product(name: "SwmCore", package: "swm-core"),
                .product(name: "SwmEigen", package: "swm-eigen"),
                .product(name: "SwmKR", package: "swm-kr"),
                .product(name: "SwmxBigInt", package: "swmx-bigint"),
                "Regex",
            ]
        ),
        .testTarget(
            name: "krCalcTests",
            dependencies: [
                .product(name: "SwmKR", package: "swm-kr"),
                "krCalcLib",
            ]),
    ]
)
