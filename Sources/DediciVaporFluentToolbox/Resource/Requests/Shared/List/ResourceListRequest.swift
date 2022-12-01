//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol ResourceListRequest: ResourceRequest {
    var resourcesProvider: ResourcesProvider<Resource> { get }
    var resourcesValidator: ResourcesValidator<Resource> { get }
}
