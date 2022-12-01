//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

public protocol ModelCanBeDisabled: Fields & CanBeDisabled {
    var disablingDateField: FieldProperty<Self, Date?> { get }
}
