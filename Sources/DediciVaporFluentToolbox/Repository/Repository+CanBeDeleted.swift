//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

extension Repository where Item: CanBeDeleted {
    public func markAsDeleted(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        do {
            var newItem = item
            try newItem.markAsDeleted()
            return update(newItem, on: database)
        } catch {
            return (database ?? self.database).eventLoop.makeFailedFuture(error)
        }
    }

    public func markingAsDeleted(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        markAsDeleted(item, on: database).flatMap { self.require(item.id, from: database) }
    }

    public func markAsDeleted(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.markAsDeleted($0, on: database) }, on: database.eventLoop)
        }
    }

    public func markingAsDeleted(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        markAsDeleted(items, on: database).flatMap { self.require(items.map(\.id), from: database) }
    }
}
