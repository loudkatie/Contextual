//
//  TaskItem.swift
//  Contextual
//
//  Created by Katie Richman on 11/16/25.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var location: String?        // e.g. "Trader Joe’s"
    var timeWindow: DateInterval?

    init(
        id: UUID = UUID(),
        title: String,
        location: String? = nil,
        timeWindow: DateInterval? = nil
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.timeWindow = timeWindow
    }
}
