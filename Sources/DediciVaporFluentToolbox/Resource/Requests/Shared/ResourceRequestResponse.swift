//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public protocol ResourceRequestResponse: ResponseEncodable & Content {
    associatedtype Resource: ResourceModel

    static func make(from resource: Resource, and request: Request) throws -> EventLoopFuture<Self>
}
