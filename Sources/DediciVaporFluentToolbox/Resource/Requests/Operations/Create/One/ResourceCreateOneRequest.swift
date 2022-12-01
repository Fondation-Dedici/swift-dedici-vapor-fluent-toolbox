//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceCreateOneRequest: ResourceOneRequest
    where Response: ResourceRequestResponse, Response.Resource == Resource
{
    associatedtype Body: ResourceCreateOneRequestBody where Body.Resource == Resource

    var saveInsteadOfCreate: Bool { get }
}

extension ResourceCreateOneRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

        return try resourceProvider(request)
            .unwrap(or: Abort(.internalServerError))
            .flatMap { self.resourceValidator.validating($0, considering: request) }
            .flatMap { self.saveInsteadOfCreate ? repository.saving($0) : repository.creating($0) }
            .flatMapThrowing { try Response.make(from: $0, and: request) }
            .flatMap { $0 }
    }
}
