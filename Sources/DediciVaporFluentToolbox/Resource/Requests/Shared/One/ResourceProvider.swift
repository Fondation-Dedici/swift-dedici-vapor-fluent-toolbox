//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public typealias ResourceProvider<Resource: ResourceModel> = (_ request: Request) throws -> EventLoopFuture<Resource?>
