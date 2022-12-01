//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceDeleteListRequestBody: ResourceRequestBody, ResourceListRequestBody
    where Element == Resource.IDValue {}
