//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol HasDefaultCreateListBody: ResourceModel {
    associatedtype DefaultCreateListBody: ResourceCreateListRequestBody where Self == DefaultCreateListBody.Resource
}
