//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public struct DefaultResourceReadListRequest
<ResponseItem: ResourceRequestResponse, Resource>:
    ResourceReadListRequest where ResponseItem.Resource == Resource
{
    public typealias ResponseItem = ResponseItem
    public typealias Response = [ResponseItem]
    public typealias Resource = Resource

    public let resourcesProvider: ResourcesProvider<Resource>
    public let resourcesValidator: ResourcesValidator<Resource>

    public init(resourcesValidator: ResourcesValidator<Resource>) {
        self.resourcesProvider = { (request: Request) throws -> EventLoopFuture<[Resource]?> in
            let queryBuilder = QueryBuilder<Resource>(database: request.db)

            return queryBuilder.all().map { $0 }
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
