//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public protocol ResourceModel: Model, Content where IDValue: LosslessStringConvertible {
    var id: UUID? { get set }
    var creationDate: Date { get set }
    var lastModificationDate: Date { get set }
}
