//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceCreateOneRequestBody: ResourceRequestBody {
    func asResource(considering request: Request) throws -> EventLoopFuture<Resource>
}
