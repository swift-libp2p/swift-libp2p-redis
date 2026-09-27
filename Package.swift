// swift-tools-version:6.1
//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libp2p open source project
//
// Copyright (c) 2022-2026 swift-libp2p project authors
// Licensed under MIT
//
// See LICENSE for license information
// See CONTRIBUTORS for the list of swift-libp2p project authors
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
import PackageDescription

let package = Package(
    name: "swift-libp2p-redis",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(name: "Redis", targets: ["Redis"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-server/RediStack.git",
            .upToNextMajor(from: "1.4.1")
        ),
        .package(
            url: "https://github.com/swift-libp2p/swift-libp2p.git",
            .upToNextMinor(from: "0.4.0")
        ),
        .package(
            url: "https://github.com/vapor/async-kit.git",
            .upToNextMajor(from: "1.22.0")
        ),
    ],
    targets: [
        .target(
            name: "Redis",
            dependencies: [
                .product(name: "RediStack", package: "RediStack"),
                .product(name: "LibP2P", package: "swift-libp2p"),
                .product(name: "AsyncKit", package: "async-kit"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=complete"),
                .enableUpcomingFeature("ExistentialAny"),
            ]
        ),
        .testTarget(
            name: "RedisTests",
            dependencies: [
                .target(name: "Redis")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=complete"),
                .enableUpcomingFeature("ExistentialAny"),
            ]
        ),
    ]
)
