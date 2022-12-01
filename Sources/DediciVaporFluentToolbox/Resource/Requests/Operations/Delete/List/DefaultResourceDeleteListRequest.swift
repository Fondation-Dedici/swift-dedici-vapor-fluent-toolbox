//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceDeleteListRequest<Body: ResourceDeleteListRequestBody, Resource>: ResourceDeleteListRequest
    where Body.Resource == Resource
{
    public typealias Body = Body
    public typealias Resource = Resource

    public let resourcesProvider: ResourcesProvider<Resource>
    public let resourcesValidator: ResourcesValidator<Resource>

    public init(resourcesValidator: ResourcesValidator<Resource>) {
        self.resourcesProvider = { (request: Request) throws -> EventLoopFuture<[Resource]?> in
            let body = try Body.extract(from: request)
            let repository = request.repositories.get(for: DefaultRepository<Resource>.self)
            let ids = try Body.validate(body.map { $0 })

            return repository.find(ids)
        }
        self.resourcesValidator = resourcesValidator
    }

    public init(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource>
    ) {
        self.resourcesProvider = resourcesProvider
        self.resourcesValidator = resourcesValidator
    }
}
