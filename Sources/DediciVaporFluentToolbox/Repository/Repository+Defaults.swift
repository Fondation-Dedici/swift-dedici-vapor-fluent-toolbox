//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation
import Vapor

extension Repository {
    public func find(_ id: Item.IDValue?, from database: Database? = nil) -> EventLoopFuture<Item?> {
        Item.find(id, on: database ?? self.database)
    }

    public func find<S: Sequence>(
        _ ids: S,
        from database: Database? = nil
    ) -> EventLoopFuture<[Item]?> where S.Element == Item.IDValue? {
        let unwrappedIds = Set(ids.compactMap { $0 })
        guard unwrappedIds.count == ids.map({ $0 }).count else {
            return (database ?? self.database).eventLoop.makeSucceededFuture(nil)
        }
        return Item.query(on: database ?? self.database)
            .filter(\._$id ~~ unwrappedIds)
            .all()
            .map { Set($0.compactMap(\.id)) == unwrappedIds ? $0 : nil }
    }

    public func require(_ id: Item.IDValue?, from database: Database? = nil) -> EventLoopFuture<Item> {
        find(id, from: database).unwrap(or: RepositoryError.itemNotFound)
    }

    public func require<S: Sequence>(
        _ ids: S,
        from database: Database? = nil
    ) -> EventLoopFuture<[Item]> where S.Element == Item.IDValue? {
        find(ids, from: database).unwrap(or: RepositoryError.itemNotFound)
    }

    public func all(from database: Database? = nil) -> EventLoopFuture<[Item]> {
        Item.query(on: database ?? self.database).all()
    }

    public func save(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        item.save(on: database ?? self.database)
    }

    public func saving(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        save(item, on: database).flatMap { self.require(item.id) }
    }

    public func save(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.save($0, on: database) }, on: database.eventLoop)
        }
    }

    public func saving(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        save(items, on: database)
            .flatMapThrowing { try items.map { try $0.requireID() } }
            .flatMap { self.require($0, from: database) }
    }

    public func create(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        item.create(on: database ?? self.database)
    }

    public func creating(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        create(item, on: database).flatMap { self.require(item.id) }
    }

    public func create(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.create($0, on: database) }, on: database.eventLoop)
        }
    }

    public func creating(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        create(items, on: database)
            .flatMapThrowing { try items.map { try $0.requireID() } }
            .flatMap { self.require($0, from: database) }
    }

    public func update(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Void> {
        item.update(on: database ?? self.database)
    }

    public func updating(_ item: Item, on database: Database? = nil) -> EventLoopFuture<Item> {
        update(item, on: database).flatMap { self.require(item.id) }
    }

    public func update(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.update($0, on: database) }, on: database.eventLoop)
        }
    }

    public func updating(_ items: [Item], on database: Database? = nil) -> EventLoopFuture<[Item]> {
        update(items, on: database)
            .flatMapThrowing { try items.map { try $0.requireID() } }
            .flatMap { self.require($0, from: database) }
    }

    public func delete(
        _ id: Item.IDValue?,
        require: Bool = false,
        force: Bool = false,
        on database: Database? = nil
    ) -> EventLoopFuture<Void> {
        if require {
            return find(id, from: database)
                .optionalFlatMap { self.delete($0, force: force, on: database) }
                .map { _ in }
        } else {
            return self.require(id, from: database)
                .flatMap { self.delete($0, force: force, on: database) }
        }
    }

    public func delete(_ item: Item, force: Bool = false, on database: Database? = nil) -> EventLoopFuture<Void> {
        item.delete(force: force, on: database ?? self.database)
    }

    public func deleting(_ item: Item, force: Bool = false, on database: Database? = nil) -> EventLoopFuture<Item> {
        delete(item, force: force, on: database).flatMap { self.require(item.id) }
    }

    public func delete(_ items: [Item], force _: Bool = false, on database: Database? = nil) -> EventLoopFuture<Void> {
        (database ?? self.database).transaction { (database: Database) -> EventLoopFuture<Void> in
            .andAllSucceed(items.map { self.delete($0, on: database) }, on: database.eventLoop)
        }
    }

    public func deleting(
        _ items: [Item],
        force _: Bool = false,
        on database: Database? = nil
    ) -> EventLoopFuture<[Item]> {
        delete(items, on: database)
            .flatMapThrowing { try items.map { try $0.requireID() } }
            .flatMap { self.require($0, from: database) }
    }
}
