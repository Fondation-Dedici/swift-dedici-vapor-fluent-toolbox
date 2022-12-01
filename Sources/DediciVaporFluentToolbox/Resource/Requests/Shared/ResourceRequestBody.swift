//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceRequestBody: Content {
    associatedtype Resource: ResourceModel
}

extension ResourceRequestBody {
    public static func extract(from request: Request) throws -> Self {
        if let validatableType = Self.self as? Validatable.Type {
            try validatableType.validate(content: request)
        }

        return try request.content.decode(Self.self)
    }
}
