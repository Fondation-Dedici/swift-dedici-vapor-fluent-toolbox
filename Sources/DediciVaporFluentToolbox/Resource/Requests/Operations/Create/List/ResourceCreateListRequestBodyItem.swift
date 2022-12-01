//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceCreateListRequestBodyItem {
    associatedtype Resource: ResourceModel

    var resourceId: Resource.IDValue { get }

    func asResource(considering request: Request) throws -> EventLoopFuture<Resource>
}
