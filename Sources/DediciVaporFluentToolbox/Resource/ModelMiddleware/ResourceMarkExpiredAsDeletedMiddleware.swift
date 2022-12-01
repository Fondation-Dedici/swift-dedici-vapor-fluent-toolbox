//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Foundation
import Vapor

public struct ResourceMarkExpiredAsDeletedMiddleware
<Resource: ResourceModel & ModelCanExpire & ModelCanBeDeleted>: Middleware {
    public init() {}

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        request.repositories
            .get(for: DefaultRepository<Resource>.self)
            .markExpiredAsDeleted()
            .flatMapAlways { _ in next.respond(to: request) }
    }
}
