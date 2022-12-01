//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol HasDefaultUpdateListBody: ResourceModel {
    associatedtype DefaultUpdateListBody: ResourceUpdateListRequestBody where Self == DefaultUpdateListBody.Resource
}
