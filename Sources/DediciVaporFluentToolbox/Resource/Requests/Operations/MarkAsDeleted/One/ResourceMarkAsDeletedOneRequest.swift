//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Foundation
import Vapor

public protocol ResourceMarkAsDeletedOneRequest: ResourceOneRequest
    where Response: ResourceRequestResponse, Response.Resource == Resource, Resource: CanBeDeleted {}

extension ResourceMarkAsDeletedOneRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

        return try resourceProvider(request)
            .unwrap(or: Abort(.notFound))
            .flatMap { self.resourceValidator.validating($0, considering: request) }
            .flatMap { repository.markingAsDeleted($0) }
            .flatMapThrowing { try Response.make(from: $0, and: request) }
            .flatMap { $0 }
    }
}
