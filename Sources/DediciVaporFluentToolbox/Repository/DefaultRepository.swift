//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation

open class DefaultRepository<Item: Model>: Repository {
    public typealias Item = Item

    public var database: Database

    public required init(database: Database) {
        self.database = database
    }
}
