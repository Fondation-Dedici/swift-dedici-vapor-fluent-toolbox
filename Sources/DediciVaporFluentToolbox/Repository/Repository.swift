//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation

public protocol Repository {
    associatedtype Item: Model
    var database: Database { get }

    func find(_ id: Item.IDValue?, from database: Database?) -> EventLoopFuture<Item?>
    func find<S: Sequence>(
        _ ids: S,
        from database: Database?
    ) -> EventLoopFuture<[Item]?> where S.Element == Item.IDValue?
    func require(_ id: Item.IDValue?, from database: Database?) -> EventLoopFuture<Item>
    func require<S: Sequence>(
        _ ids: S,
        from database: Database?
    ) -> EventLoopFuture<[Item]> where S.Element == Item.IDValue?
    func all(from database: Database?) -> EventLoopFuture<[Item]>

    func save(_ item: Item, on database: Database?) -> EventLoopFuture<Void>
    func saving(_ item: Item, on database: Database?) -> EventLoopFuture<Item>
    func save(_ items: [Item], on database: Database?) -> EventLoopFuture<Void>
    func saving(_ items: [Item], on database: Database?) -> EventLoopFuture<[Item]>

    func create(_ item: Item, on database: Database?) -> EventLoopFuture<Void>
    func creating(_ item: Item, on database: Database?) -> EventLoopFuture<Item>
    func create(_ items: [Item], on database: Database?) -> EventLoopFuture<Void>
    func creating(_ items: [Item], on database: Database?) -> EventLoopFuture<[Item]>

    func update(_ item: Item, on database: Database?) -> EventLoopFuture<Void>
    func updating(_ item: Item, on database: Database?) -> EventLoopFuture<Item>
    func update(_ items: [Item], on database: Database?) -> EventLoopFuture<Void>
    func updating(_ items: [Item], on database: Database?) -> EventLoopFuture<[Item]>

    func delete(_ id: Item.IDValue?, require: Bool, force: Bool, on database: Database?) -> EventLoopFuture<Void>
    func delete(_ item: Item, force: Bool, on database: Database?) -> EventLoopFuture<Void>
    func deleting(_ item: Item, force: Bool, on database: Database?) -> EventLoopFuture<Item>
    func delete(_ items: [Item], force: Bool, on database: Database?) -> EventLoopFuture<Void>
    func deleting(_ items: [Item], force: Bool, on database: Database?) -> EventLoopFuture<[Item]>

    init(database: Database)
}
