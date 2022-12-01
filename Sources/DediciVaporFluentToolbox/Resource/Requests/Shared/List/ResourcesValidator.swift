//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct ResourcesValidator<Resource: ResourceModel> {
    private var validator: (_ resources: [Resource], _ request: Request) -> EventLoopFuture<Void>

    public init() {
        self.validator = { _, request in request.eventLoop.makeSucceededFuture(()) }
    }

    public init(_ validator: @escaping (_ resources: [Resource], _ request: Request) throws -> EventLoopFuture<Void>) {
        self.validator = {
            do {
                return try validator($0, $1)
            } catch {
                return $1.eventLoop.makeFailedFuture(error)
            }
        }
    }

    public init(_ validator: @escaping (_ resources: [Resource], _ request: Request) throws -> Void) {
        self.validator = {
            do {
                return $1.eventLoop.makeSucceededFuture(try validator($0, $1))
            } catch {
                return $1.eventLoop.makeFailedFuture(error)
            }
        }
    }

    public func validate(_ resources: [Resource], considering request: Request) -> EventLoopFuture<Void> {
        validator(resources, request)
    }

    public func validating(_ resources: [Resource], considering request: Request) -> EventLoopFuture<[Resource]> {
        validator(resources, request).map { resources }
    }
}
