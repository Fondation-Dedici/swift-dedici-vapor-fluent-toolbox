//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

extension Application {
    public enum AutoMigrationError: Error {
        case autoMigrateFailedTooManyTimes(maxAttempts: Int)
    }

    public func autoMigrateUntilSuccess(
        retryAfter: UInt32 = 5,
        retryDelayMultiplier: Double = 1.5,
        maxRetryDelay: UInt32 = 60,
        maxAttempts: Int = 20
    ) -> EventLoopFuture<Void> {
        let maxDelay = max(min(60, maxRetryDelay), 5)
        var delay: UInt32 = min(max(retryAfter, 5), maxDelay)
        let delayMultiplier: Double = max(1, retryDelayMultiplier)
        var attempt = 0
        let maxAttempts = max(maxAttempts, 1)

        while true {
            do {
                logger.notice("Attempting (#: \(attempt + 1)/\(maxAttempts)) to auto-migrate database(s)…")
                try autoMigrate().wait()
                logger.notice("Database(s) auto-migration completed successfully")
                return eventLoopGroup.future()
            } catch {
                logger.error("Database(s) auto-migration failed because: \(error)")
            }
            attempt += 1
            guard attempt < maxAttempts else { break }
            logger.notice("Waiting \(delay)s before next auto-migration attempt…")
            sleep(delay)
            delay = min(UInt32(Double(delay) * delayMultiplier), 60)
        }

        return eventLoopGroup.future(error: AutoMigrationError.autoMigrateFailedTooManyTimes(maxAttempts: maxAttempts))
    }
}
