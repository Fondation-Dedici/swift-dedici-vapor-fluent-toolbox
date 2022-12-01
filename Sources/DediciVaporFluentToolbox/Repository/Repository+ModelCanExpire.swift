//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

extension Repository where Item: ModelCanExpire {
    public func deleteExpired(on database: Database? = nil) -> EventLoopFuture<Void> {
        Item.query(on: database ?? self.database)
            .filter(\.expirationDateField != nil)
            .filter(\.expirationDateField <= Date())
            .delete()
    }
}
