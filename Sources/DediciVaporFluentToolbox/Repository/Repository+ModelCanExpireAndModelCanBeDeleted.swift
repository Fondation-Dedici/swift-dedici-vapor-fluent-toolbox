//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import DediciVaporToolbox
import Fluent
import Foundation

extension Repository where Item: ModelCanExpire & ModelCanBeDeleted {
    public func markExpiredAsDeleted(on database: Database? = nil) -> EventLoopFuture<Void> {
        Item.query(on: database ?? self.database)
            .filter(\.expirationDateField != nil)
            .filter(\.expirationDateField <= Date())
            .filter(\.deletionDateField <= Date())
            .all()
            .flatMap { self.markAsDeleted($0, on: database) }
    }
}
