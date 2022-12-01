//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol HasDefaultCreateOneBody: ResourceModel {
    associatedtype DefaultCreateOneBody: ResourceCreateOneRequestBody where Self == DefaultCreateOneBody.Resource
}
