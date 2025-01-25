// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalendarCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CalendarCore",
            targets: ["CalendarCore"]),

        .library(
            name: "CalendarDomain",
            targets: ["CalendarDomain"]),

        .library(
            name: "CalendarNetwork",
            targets: ["CalendarNetwork"]),

        .library(
            name: "CalendarUI",
            targets: ["CalendarUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase-community/supabase-swift.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "CalendarCore",
            dependencies: [
                "CalendarDomain"
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "CalendarCoreTests",
            dependencies: ["CalendarCore"]
        ),

        .target(
            name: "CalendarDomain"),

        .target(
            name: "CalendarNetwork",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                "CalendarDomain"
            ]),
        
        .target(
            name: "CalendarUI",
            dependencies: [
                "CalendarCore",
                "CalendarDomain"
            ]),
    ]
)
