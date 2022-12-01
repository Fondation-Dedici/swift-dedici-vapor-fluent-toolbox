//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceRequest {
    associatedtype Resource: ResourceModel
    associatedtype Response: ResponseEncodable

    func handle(request: Request) throws -> EventLoopFuture<Response>
}
