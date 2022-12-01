//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

public protocol HasDefaultResponse: ResourceModel {
    associatedtype DefaultResponse: ResourceRequestResponse where Self == DefaultResponse.Resource
}
