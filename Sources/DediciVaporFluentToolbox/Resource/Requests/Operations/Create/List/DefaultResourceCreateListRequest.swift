//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceCreateListRequest
<Body: ResourceCreateListRequestBody, ResponseItem: ResourceRequestResponse, Resource>:
    ResourceCreateListRequest where Body.Resource == ResponseItem.Resource, Body.Resource == Resource
{
    public typealias Body = Body
    public typealias ResponseItem = ResponseItem
    public typealias Response = [ResponseItem]
    public typealias Resource = Resource

    public let resourcesProvider: ResourcesProvider<Resource>
    public let resourcesValidator: ResourcesValidator<Resource>
    public let saveInsteadOfCreate: Bool

    public init(
        resourcesValidator: ResourcesValidator<Resource>,
        saveInsteadOfCreate: Bool
    ) {
        self.resourcesProvider = { (request: Request) throws -> EventLoopFuture<[Resource]?> in
            let body = try Body.extract(from: request)
            try Body.validate(body.map(\.resourceId))
            let resources = try body.map { try $0.asResource(considering: request) }

            return EventLoopFuture<Resource>.whenAllSucceed(resources, on: request.eventLoop).map { $0 }
        }
        self.resourcesValidator = resourcesValidator
        self.saveInsteadOfCreate = saveInsteadOfCreate
    }

    public init(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource>,
        saveInsteadOfCreate: Bool = false
    ) {
        self.resourcesProvider = resourcesProvider
        self.resourcesValidator = resourcesValidator
        self.saveInsteadOfCreate = saveInsteadOfCreate
    }
}
