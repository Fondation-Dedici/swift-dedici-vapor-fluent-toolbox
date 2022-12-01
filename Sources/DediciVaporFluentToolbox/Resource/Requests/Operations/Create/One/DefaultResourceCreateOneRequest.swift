//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct DefaultResourceCreateOneRequest
<Body: ResourceCreateOneRequestBody, Response: ResourceRequestResponse, Resource>:
    ResourceCreateOneRequest where Body.Resource == Response.Resource, Body.Resource == Resource
{
    public typealias Body = Body
    public typealias Response = Response
    public typealias Resource = Resource

    public let resourceProvider: ResourceProvider<Resource>
    public let resourceValidator: ResourceValidator<Resource>
    public let saveInsteadOfCreate: Bool

    public init(resourceValidator: ResourceValidator<Resource>, saveInsteadOfCreate: Bool) {
        self.resourceProvider = { (request: Request) throws -> EventLoopFuture<Resource?> in
            let body = try Body.extract(from: request)
            return try body.asResource(considering: request).map { $0 }
        }
        self.resourceValidator = resourceValidator
        self.saveInsteadOfCreate = saveInsteadOfCreate
    }

    public init(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource>,
        saveInsteadOfCreate: Bool
    ) {
        self.resourceProvider = resourceProvider
        self.resourceValidator = resourceValidator
        self.saveInsteadOfCreate = saveInsteadOfCreate
    }
}
