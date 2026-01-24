//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libp2p open source project
//
// Copyright (c) 2022-2025 swift-libp2p project authors
// Licensed under MIT
//
// See LICENSE for license information
// See CONTRIBUTORS for the list of swift-libp2p project authors
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
//  Created by Vapor
//  Modified by swift-libp2p
//

import Foundation
import LibP2P
import Logging
@preconcurrency import Redis
import Testing

extension RedisID {
    fileprivate static let one: RedisID = "one"
    fileprivate static let two: RedisID = "two"
}

@Suite("Multiple Redis Tests")
struct MultipleRedisTests {

    var redisConfig: RedisConfiguration!
    var redisConfig2: RedisConfiguration!

    init() throws {
        redisConfig = try RedisConfiguration(
            hostname: Environment.get("REDIS_HOSTNAME") ?? "localhost",
            port: Environment.get("REDIS_PORT")?.int ?? 6379,
            pool: .init(connectionRetryTimeout: .milliseconds(100))
        )
        redisConfig2 = try RedisConfiguration(
            hostname: Environment.get("REDIS_HOSTNAME_2") ?? "localhost",
            port: Environment.get("REDIS_PORT_2")?.int ?? 6380,
            pool: .init(connectionRetryTimeout: .milliseconds(100))
        )
    }

    @Test func testApplicationRedis() throws {
        let app = Application()
        defer { app.shutdown() }

        app.redis(.one).configuration = redisConfig
        app.redis(.two).configuration = redisConfig2

        try app.boot()

        let info1 = try app.redis(.one).send(command: "INFO").wait()
        let info1String = try #require(info1.string)
        #expect(info1String.contains("redis_version"))

        let info2 = try app.redis(.two).send(command: "INFO").wait()
        let info2String = try #require(info2.string)
        #expect(info2String.contains("redis_version"))
    }

    //func testSetAndGet() throws {
    //    let app = Application()
    //    defer { app.shutdown() }
    //
    //    app.redis(.one).configuration = redisConfig
    //    app.redis(.two).configuration = redisConfig2
    //
    //    app.get("test1") { req in
    //        req.redis(.one).get("name").map {
    //            $0.description
    //        }
    //    }
    //    app.get("test2") { req in
    //        req.redis(.two).get("name").map {
    //            $0.description
    //        }
    //    }
    //
    //    try app.boot()
    //
    //    try app.redis(.one).set("name", to: "redis1").wait()
    //    try app.redis(.two).set("name", to: "redis2").wait()
    //
    //    try app.test(.GET, "test1") { res in
    //        XCTAssertEqual(res.body.string, "redis1")
    //    }
    //
    //    try app.test(.GET, "test2") { res in
    //        XCTAssertEqual(res.body.string, "redis2")
    //    }
    //
    //    XCTAssertEqual("redis1", try app.redis(.one).get("name").wait().string)
    //    XCTAssertEqual("redis2", try app.redis(.two).get("name").wait().string)
    //}
}
