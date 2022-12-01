//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Foundation
import Vapor

public struct ResourceDeleteExpiredMiddleware<Resource: ResourceModel & ModelCanExpire>: Middleware {
    public init() {}

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        request.repositories
            .get(for: DefaultRepository<Resource>.self)
            .deleteExpired()
            .flatMapAlways { _ in next.respond(to: request) }
    }
}
