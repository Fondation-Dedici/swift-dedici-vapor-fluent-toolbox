//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public protocol ResourceListRequestBody: Collection where Index == Int, Element: Codable {
    associatedtype Resource: ResourceModel

    var items: [Element] { get }
    init(items: [Element])
}

extension ResourceListRequestBody {
    public var startIndex: Index { items.startIndex }
    public var endIndex: Index { items.endIndex }

    public subscript(position: Index) -> Element { items[position] }

    public func index(after index: Int) -> Int {
        items.index(after: index)
    }
}

extension ResourceListRequestBody {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(items: try container.decode([Element].self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(items)
    }
}

extension ResourceListRequestBody {
    @discardableResult
    static func validate<S: Sequence>(_ ids: S) throws -> Set<Resource.IDValue> where S.Element == Resource.IDValue {
        let ids: Set<Self.Resource.IDValue> = Set(ids)
        guard ids.count == ids.count else {
            var allIds = ids.map { $0 }
            for id in ids {
                guard let index = allIds.firstIndex(where: { $0 == id }) else { continue }
                allIds.remove(at: index)
            }
            let duplicatesString = allIds.map { "\($0)" }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "List contains duplicates: [\(duplicatesString)]")
        }
        return ids
    }
}
