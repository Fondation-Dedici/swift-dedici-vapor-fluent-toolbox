//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public protocol ResourceReadListRequest: ResourceListRequest
    where Response == [ResponseItem]
{
    associatedtype ResponseItem: ResourceRequestResponse where ResponseItem.Resource == Resource
}

extension ResourceReadListRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        try resourcesProvider(request)
            .unwrap(or: Abort(.badRequest))
            .flatMap { self.resourcesValidator.validating($0, considering: request) }
            .flatMapThrowing { try $0.map { try ResponseItem.make(from: $0, and: request) } }
            .flatMap { EventLoopFuture.whenAllSucceed($0, on: request.eventLoop) }
    }
}
