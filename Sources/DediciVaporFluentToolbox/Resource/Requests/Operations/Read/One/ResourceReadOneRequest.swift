//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public protocol ResourceReadOneRequest: ResourceOneRequest
    where Response: ResourceRequestResponse, Response.Resource == Resource {}

extension ResourceReadOneRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        try resourceProvider(request)
            .unwrap(or: Abort(.notFound))
            .flatMap { self.resourceValidator.validating($0, considering: request) }
            .flatMapThrowing { try Response.make(from: $0, and: request) }
            .flatMap { $0 }
    }
}
