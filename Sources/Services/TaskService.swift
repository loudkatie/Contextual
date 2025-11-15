//
//  TaskService.swift
//  Contextual
//

import Foundation
import Combine

final class TaskService: ObservableObject {
    static let shared = TaskService()

    @Published var tasks: [TaskItem] = []

    private init() {}

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
}
