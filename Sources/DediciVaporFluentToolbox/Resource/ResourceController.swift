//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation
import Vapor

public protocol ResourceController {
    associatedtype Resource: ResourceModel
}

extension ResourceController where Resource: HasDefaultCreateOneBody & HasDefaultResponse {
    public func defaultCreateOne(
        resourceValidator: ResourceValidator<Resource> = .init(),
        saveInsteadOfCreate: Bool = false
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceCreateOneRequest<Resource.DefaultCreateOneBody, Resource.DefaultResponse, Resource>(
                resourceValidator: resourceValidator,
                saveInsteadOfCreate: saveInsteadOfCreate
            )
            .handle(request: $0)
        }
    }

    public func defaultCreateOne(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource> = .init(),
        saveInsteadOfCreate: Bool = false
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceCreateOneRequest<Resource.DefaultCreateOneBody, Resource.DefaultResponse, Resource>(
                resourceProvider: resourceProvider,
                resourceValidator: resourceValidator,
                saveInsteadOfCreate: saveInsteadOfCreate
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultCreateListBody & HasDefaultResponse {
    public func defaultCreateList(
        resourcesValidator: ResourcesValidator<Resource> = .init(),
        saveInsteadOfCreate: Bool = false
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceCreateListRequest<Resource.DefaultCreateListBody, Resource.DefaultResponse, Resource>(
                resourcesValidator: resourcesValidator,
                saveInsteadOfCreate: saveInsteadOfCreate
            )
            .handle(request: $0)
        }
    }

    public func defaultCreateList(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource> = .init(),
        saveInsteadOfCreate: Bool = false
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceCreateListRequest<Resource.DefaultCreateListBody, Resource.DefaultResponse, Resource>(
                resourcesProvider: resourcesProvider,
                resourcesValidator: resourcesValidator,
                saveInsteadOfCreate: saveInsteadOfCreate
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultUpdateOneBody & HasDefaultResponse {
    public func defaultUpdateOne(
        idPathComponentName: String,
        resourceValidator: ResourceValidator<Resource> = .init(),
        saveInsteadOfUpdate: Bool = false
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceUpdateOneRequest<Resource.DefaultUpdateOneBody, Resource.DefaultResponse, Resource>(
                idPathComponentName: idPathComponentName,
                resourceValidator: resourceValidator,
                saveInsteadOfUpdate: saveInsteadOfUpdate
            )
            .handle(request: $0)
        }
    }

    public func defaultUpdateOne(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource> = .init(),
        saveInsteadOfUpdate: Bool = false
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceUpdateOneRequest<Resource.DefaultUpdateOneBody, Resource.DefaultResponse, Resource>(
                resourceProvider: resourceProvider,
                resourceValidator: resourceValidator,
                saveInsteadOfUpdate: saveInsteadOfUpdate
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultUpdateListBody & HasDefaultResponse {
    public func defaultUpdateList(
        resourcesValidator: ResourcesValidator<Resource> = .init(),
        saveInsteadOfUpdate: Bool = false
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceUpdateListRequest<Resource.DefaultUpdateListBody, Resource.DefaultResponse, Resource>(
                resourcesValidator: resourcesValidator,
                saveInsteadOfUpdate: saveInsteadOfUpdate
            )
            .handle(request: $0)
        }
    }

    public func defaultUpdateList(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource> = .init(),
        saveInsteadOfUpdate: Bool = false
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceUpdateListRequest<Resource.DefaultUpdateListBody, Resource.DefaultResponse, Resource>(
                resourcesProvider: resourcesProvider,
                resourcesValidator: resourcesValidator,
                saveInsteadOfUpdate: saveInsteadOfUpdate
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController {
    public func defaultDeleteOne(
        idPathComponentName: String,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Response> {
        {
            try DefaultResourceDeleteOneRequest<Resource>(
                idPathComponentName: idPathComponentName,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }

    public func defaultDeleteOne(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Response> {
        {
            try DefaultResourceDeleteOneRequest<Resource>(
                resourceProvider: resourceProvider,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultDeleteListBody & HasDefaultResponse {
    public func defaultDeleteList(
        resourcesValidator: ResourcesValidator<Resource> = .init()
    ) -> RequestHandler<Response> {
        {
            try DefaultResourceDeleteListRequest<Resource.DefaultDeleteListBody, Resource>(
                resourcesValidator: resourcesValidator
            )
            .handle(request: $0)
        }
    }

    public func defaultDeleteList(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource> = .init()
    ) -> RequestHandler<Response> {
        {
            try DefaultResourceDeleteListRequest<Resource.DefaultDeleteListBody, Resource>(
                resourcesProvider: resourcesProvider,
                resourcesValidator: resourcesValidator
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultResponse {
    public func defaultReadOne(
        idPathComponentName: String,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceReadOneRequest<Resource.DefaultResponse, Resource>(
                idPathComponentName: idPathComponentName,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }

    public func defaultReadOne(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceReadOneRequest<Resource.DefaultResponse, Resource>(
                resourceProvider: resourceProvider,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultResponse {
    public func defaultReadList(
        resourcesValidator: ResourcesValidator<Resource> = .init()
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceReadListRequest<Resource.DefaultResponse, Resource>(
                resourcesValidator: resourcesValidator
            )
            .handle(request: $0)
        }
    }

    public func defaultReadList(
        resourcesProvider: @escaping ResourcesProvider<Resource>,
        resourcesValidator: ResourcesValidator<Resource> = .init()
    ) -> RequestHandler<[Resource.DefaultResponse]> {
        {
            try DefaultResourceReadListRequest<Resource.DefaultResponse, Resource>(
                resourcesProvider: resourcesProvider,
                resourcesValidator: resourcesValidator
            )
            .handle(request: $0)
        }
    }
}

extension ResourceController where Resource: HasDefaultResponse & CanBeDeleted {
    public func defaultMarkAsDeletedOne(
        idPathComponentName: String,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceMarkAsDeletedOneRequest<Resource.DefaultResponse, Resource>(
                idPathComponentName: idPathComponentName,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }

    public func defaultMarkAsDeletedOne(
        resourceProvider: @escaping ResourceProvider<Resource>,
        resourceValidator: ResourceValidator<Resource> = .init()
    ) -> RequestHandler<Resource.DefaultResponse> {
        {
            try DefaultResourceMarkAsDeletedOneRequest<Resource.DefaultResponse, Resource>(
                resourceProvider: resourceProvider,
                resourceValidator: resourceValidator
            )
            .handle(request: $0)
        }
    }
}
