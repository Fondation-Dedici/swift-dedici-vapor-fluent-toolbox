//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceDeleteOneRequest<Resource: ResourceModel>: ResourceDeleteOneRequest {
    public typealias Response = Vapor.Response
    public typealias Resource = Resource

    public let resourceProvider: ResourceProvider<Resource>
    public let resourceValidator: ResourceValidator<Resource>

    public init(idPathComponentName: String, resourceValidator: ResourceValidator<Resource>) {
        self.resourceProvider = { (request: Request) throws -> EventLoopFuture<Resource?> in
            let resourceId: Resource.IDValue? = request.parameters.get(idPathComponentName)
            let repository: DefaultRepository<Resource> = request.repositories.get()

            return repository.find(resourceId)
        }
        self.resourceValidator = resourceValidator
    }

    public init(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource>
    ) {
        self.resourceProvider = resourceProvider
        self.resourceValidator = resourceValidator
    }
}
