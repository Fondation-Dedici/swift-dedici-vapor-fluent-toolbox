//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceUpdateOneRequest
<Body: ResourceUpdateOneRequestBody, Response: ResourceRequestResponse, Resource>:
    ResourceUpdateOneRequest where Body.Resource == Response.Resource, Body.Resource == Resource
{
    public typealias Body = Body
    public typealias Response = Response
    public typealias Resource = Resource

    public let resourceProvider: ResourceProvider<Resource>
    public let resourceValidator: ResourceValidator<Resource>
    public let saveInsteadOfUpdate: Bool

    public init(
        idPathComponentName: String,
        resourceValidator: ResourceValidator<Resource>,
        saveInsteadOfUpdate: Bool
    ) {
        self.resourceProvider = { (request: Request) throws -> EventLoopFuture<Resource?> in
            let resourceId: Resource.IDValue? = request.parameters.get(idPathComponentName)
            let repository = request.repositories.get(for: DefaultRepository<Resource>.self)

            return repository.find(resourceId)
        }
        self.resourceValidator = resourceValidator
        self.saveInsteadOfUpdate = saveInsteadOfUpdate
    }

    public init(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource>,
        saveInsteadOfUpdate: Bool
    ) {
        self.resourceProvider = resourceProvider
        self.resourceValidator = resourceValidator
        self.saveInsteadOfUpdate = saveInsteadOfUpdate
    }
}
