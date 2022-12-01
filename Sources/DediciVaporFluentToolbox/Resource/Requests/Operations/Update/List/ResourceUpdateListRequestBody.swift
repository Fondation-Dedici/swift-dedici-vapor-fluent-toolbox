//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceUpdateListRequestBody: ResourceRequestBody, ResourceListRequestBody
    where Item.Resource == Resource, Element == Item
{
    associatedtype Item: ResourceUpdateListRequestBodyItem
}
