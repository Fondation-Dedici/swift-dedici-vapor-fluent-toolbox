//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol ResourceOneRequest: ResourceRequest {
    var resourceProvider: ResourceProvider<Resource> { get }
    var resourceValidator: ResourceValidator<Resource> { get }
}
