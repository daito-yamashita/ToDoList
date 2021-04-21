//
//  ToDo.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/21.
//

import UIKit

struct ToDo: Hashable {
    enum Category: Int, CaseIterable {
        case sample
    }
    let task: String
    var identifier = UUID()
    
    init(task: String) {
        self.task = task
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension ToDo.Category {
    var todos: [ToDo] {
        return [
            ToDo(task: "task0"),
            ToDo(task: "task1"),
            ToDo(task: "task2"),
            ToDo(task: "task3"),
            ToDo(task: "task4"),
            ToDo(task: "task5"),
            ToDo(task: "task6"),
            ToDo(task: "task7"),
            ToDo(task: "task8"),
            ToDo(task: "task9"),
            ToDo(task: "task10")
        ]
    }
}

// Mark: 自作の型をUserDefalutに保存する時、Codableに準拠している必要がある
extension ToDo: Codable {
    enum CodingKeys: CodingKey {
        case task
        case identifier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        task = try container.decode(String.self, forKey: .task)
        identifier = try container.decode(UUID.self, forKey: .identifier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(task, forKey: .task)
        try container.encode(identifier, forKey: .identifier)
    }
}
