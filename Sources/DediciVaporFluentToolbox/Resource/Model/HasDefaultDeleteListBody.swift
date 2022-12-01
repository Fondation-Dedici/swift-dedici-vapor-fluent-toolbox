//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol HasDefaultDeleteListBody: ResourceModel {
    associatedtype DefaultDeleteListBody: ResourceDeleteListRequestBody where Self == DefaultDeleteListBody.Resource
}
