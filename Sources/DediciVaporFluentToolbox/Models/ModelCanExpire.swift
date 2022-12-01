//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

public protocol ModelCanExpire: Fields & CanExpire {
    var expirationDateField: FieldProperty<Self, Date?> { get }
}
