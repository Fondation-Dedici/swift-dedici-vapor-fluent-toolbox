//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceUpdateListRequest: ResourceListRequest where Response == [ResponseItem] {
    associatedtype Body: ResourceUpdateListRequestBody where Body.Resource == Resource
    associatedtype ResponseItem: ResourceRequestResponse where ResponseItem.Resource == Resource

    var saveInsteadOfUpdate: Bool { get }
}

extension ResourceUpdateListRequest {
    public func handle(request: Request) throws -> EventLoopFuture<Response> {
        let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

        return try resourcesProvider(request)
            .unwrap(or: Abort(.badRequest))
            .flatMap { self.resourcesValidator.validating($0, considering: request) }
            .flatMap { self.saveInsteadOfUpdate ? repository.saving($0) : repository.updating($0) }
            .flatMapThrowing { try $0.map { try ResponseItem.make(from: $0, and: request) } }
            .flatMap { EventLoopFuture.whenAllSucceed($0, on: request.eventLoop) }
    }
}
