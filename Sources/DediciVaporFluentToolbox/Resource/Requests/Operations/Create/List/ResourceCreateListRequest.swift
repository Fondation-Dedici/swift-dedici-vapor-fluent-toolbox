//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceCreateListRequest: ResourceListRequest
    where Response == [ResponseItem]
{
    associatedtype Body: ResourceCreateListRequestBody where Body.Resource == Resource
    associatedtype ResponseItem: ResourceRequestResponse where ResponseItem.Resource == Resource

    var saveInsteadOfCreate: Bool { get }
}

extension ResourceCreateListRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository: DefaultRepository<Resource> = request.repositories.get()

        return try resourcesProvider(request)
            .unwrap(or: Abort(.badRequest))
            .flatMap { self.resourcesValidator.validating($0, considering: request) }
            .flatMap { self.saveInsteadOfCreate ? repository.saving($0) : repository.creating($0) }
            .flatMapThrowing { try $0.map { try ResponseItem.make(from: $0, and: request) } }
            .flatMap { EventLoopFuture.whenAllSucceed($0, on: request.eventLoop) }
    }
}
