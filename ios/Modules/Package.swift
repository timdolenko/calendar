// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalendarCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CalendarCore",
            targets: ["CalendarCore"]),

        .library(
            name: "CalendarDomain",
            targets: ["CalendarDomain"]),

        .library(
            name: "CalendarNetwork",
            targets: ["CalendarNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase-community/supabase-swift.git", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CalendarCore",
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "CalendarCoreTests",
            dependencies: ["CalendarCore"]
        ),

        .target(
            name: "CalendarDomain"),
        .testTarget(
            name: "CalendarDomainTests",
            dependencies: ["CalendarDomain"]),

        .target(
            name: "CalendarNetwork",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                "CalendarDomain"
            ]),
        .testTarget(
            name: "CalendarNetworkTests",
            dependencies: ["CalendarNetwork"]),
        
        .target(
            name: "CalendarUI",
            dependencies: [
                "CalendarCore",
                "CalendarDomain"
            ]),
        .testTarget(
            name: "CalendarUITests",
            dependencies: ["CalendarUI"]),
    ]
)
