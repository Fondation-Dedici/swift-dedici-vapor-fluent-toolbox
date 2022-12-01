//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceUpdateOneRequest: ResourceOneRequest
    where Response: ResourceRequestResponse, Response.Resource == Resource
{
    associatedtype Body: ResourceUpdateOneRequestBody where Body.Resource == Resource

    var saveInsteadOfUpdate: Bool { get }
}

extension ResourceUpdateOneRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let body = try Body.extract(from: request)
        let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

        return try resourceProvider(request)
            .unwrap(or: Abort(.notFound))
            .flatMap { self.resourceValidator.validating($0, considering: request) }
            .flatMapThrowing { try body.apply(to: $0, considering: request) }
            .flatMap { $0 }
            .flatMap { self.saveInsteadOfUpdate ? repository.saving($0) : repository.updating($0) }
            .flatMapThrowing { try Response.make(from: $0, and: request) }
            .flatMap { $0 }
    }
}
