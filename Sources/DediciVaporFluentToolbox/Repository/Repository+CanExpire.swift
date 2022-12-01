//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

extension Repository where Item: CanExpire {
    public func markAsExpired(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        do {
            var newItem = item
            try newItem.markAsExpired()
            return update(newItem, on: database)
        } catch {
            return (database ?? self.database).eventLoop.makeFailedFuture(error)
        }
    }

    public func markingAsExpired(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        markAsExpired(item, on: database).flatMap { self.require(item.id, from: database) }
    }

    public func markAsExpired(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.markAsExpired($0, on: database) }, on: database.eventLoop)
        }
    }

    public func markingAsExpired(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        markAsExpired(items, on: database).flatMap { self.require(items.map(\.id), from: database) }
    }
}
