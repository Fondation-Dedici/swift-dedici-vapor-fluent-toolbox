//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import Vapor

public final class Repositories {
    struct Key: StorageKey {
        typealias Value = Repositories
    }

    private var storage: [ObjectIdentifier: Any]
    private let database: Database

    public init(database: Database) {
        self.storage = [:]
        self.database = database
    }

    public func get<Rep: Repository>(for _: Rep.Type = Rep.self) -> Rep {
        let repositoryId = ObjectIdentifier(Rep.self)
        guard let repository = storage[repositoryId] as? Rep else {
            let newRepository = Rep(database: database)
            storage[repositoryId] = newRepository
            return newRepository
        }
        return repository
    }
}

extension Request {
    public var repositories: Repositories {
        guard let repositories = storage[Repositories.Key.self] else {
            let newRepositories = Repositories(database: db)
            storage[Repositories.Key.self] = newRepositories
            return newRepositories
        }
        return repositories
    }
}
