//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceDeleteOneRequest: ResourceOneRequest where Response == Vapor.Response {}

extension ResourceDeleteOneRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository: DefaultRepository<Resource> = request.repositories.get()

        return try resourceProvider(request)
            .unwrap(or: Abort(.notFound))
            .flatMap { self.resourceValidator.validating($0, considering: request) }
            .flatMap { repository.delete($0) }
            .map { Vapor.Response(status: .noContent) }
    }
}
