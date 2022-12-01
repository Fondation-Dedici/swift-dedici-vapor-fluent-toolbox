//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

extension Repository where Item: CanBeDisabled {
    public func markAsDisabled(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        do {
            var newItem = item
            try newItem.markAsDisabled()
            return update(newItem, on: database)
        } catch {
            return (database ?? self.database).eventLoop.makeFailedFuture(error)
        }
    }

    public func markingAsDisabled(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        markAsDisabled(item, on: database).flatMap { self.require(item.id, from: database) }
    }

    public func markAsDisabled(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.markAsDisabled($0, on: database) }, on: database.eventLoop)
        }
    }

    public func markingAsDisabled(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        markAsDisabled(items, on: database).flatMap { self.require(items.map(\.id), from: database) }
    }
}
