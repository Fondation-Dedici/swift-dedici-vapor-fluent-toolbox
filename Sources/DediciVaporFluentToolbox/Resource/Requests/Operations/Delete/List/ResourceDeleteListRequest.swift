//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceDeleteListRequest: ResourceListRequest where Response == Vapor.Response {
    associatedtype Body: ResourceDeleteListRequestBody where Body.Resource == Resource
}

extension ResourceDeleteListRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

        return try resourcesProvider(request)
            .unwrap(or: Abort(.notFound))
            .flatMap { self.resourcesValidator.validating($0, considering: request) }
            .flatMap { repository.delete($0) }
            .map { Vapor.Response(status: .noContent) }
    }
}
