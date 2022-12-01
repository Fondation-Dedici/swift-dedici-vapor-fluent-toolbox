//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation

public struct ResourceModelMiddleware<Resource: ResourceModel>: ModelMiddleware {
    public typealias Model = Resource

    public init() {}

    public func create(model: Model, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        if model.id == nil { model.id = .init() }
        model.creationDate = .init()
        model.lastModificationDate = .init()
        return next.create(model, on: db)
    }

    public func update(model: Model, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.lastModificationDate = .init()
        return next.update(model, on: db)
    }
}
