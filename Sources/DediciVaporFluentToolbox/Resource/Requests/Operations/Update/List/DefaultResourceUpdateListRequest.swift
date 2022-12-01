//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceUpdateListRequest
<Body: ResourceUpdateListRequestBody, ResponseItem: ResourceRequestResponse, Resource>:
    ResourceUpdateListRequest where Body.Resource == ResponseItem.Resource, Body.Resource == Resource
{
    public typealias ResponseItem = ResponseItem
    public typealias Response = [ResponseItem]
    public typealias Body = Body
    public typealias Resource = Resource

    public let resourcesProvider: ResourcesProvider<Resource>
    public let resourcesValidator: ResourcesValidator<Resource>
    public let saveInsteadOfUpdate: Bool

    public init(resourcesValidator: ResourcesValidator<Resource>, saveInsteadOfUpdate: Bool) {
        self.resourcesProvider = { (request: Request) throws -> EventLoopFuture<[Resource]?> in
            let body = try Body.extract(from: request)
            let repository = request.repositories.get(for: DefaultRepository<Resource>.self)
            let ids = try Body.validate(body.map(\.resourceId))

            return repository.find(ids)
                .flatMapThrowing { (resources: [Resource]?) throws -> [EventLoopFuture<Resource>] in
                    try (resources ?? []).map { (resource: Resource) throws -> EventLoopFuture<Resource> in
                        guard let resourceUpdate = body.first(where: { $0.resourceId == resource.id }) else {
                            throw Abort(.internalServerError)
                        }
                        return try resourceUpdate.apply(to: resource, considering: request)
                    }
                }
                .flatMap { EventLoopFuture<Resource>.whenAllSucceed($0, on: request.eventLoop) }
                .map { $0 }
        }
        self.resourcesValidator = resourcesValidator
        self.saveInsteadOfUpdate = saveInsteadOfUpdate
    }

    public init(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource>,
        saveInsteadOfUpdate: Bool
    ) {
        self.resourcesProvider = resourcesProvider
        self.resourcesValidator = resourcesValidator
        self.saveInsteadOfUpdate = saveInsteadOfUpdate
    }
}
