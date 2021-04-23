//
//  ToDo.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/21.
//

import UIKit

struct ToDo: Hashable {
    enum Category: String, Codable, CaseIterable, CustomStringConvertible {
        case none, done
    }
    let task: String
    let category: Category
    let identifier = UUID()
    
    init(task: String, category: Category) {
        self.task = task
        self.category = category
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension ToDo.Category {
    // MARK:
    var description: String {
        switch self {
        case .none: return "None"
        case .done: return "Done"
        }
    }
    var todos: [ToDo] {
        switch self {
        case .none:
            return [
                ToDo(task: "task0", category: self)
            ]
        case .done:
            return [
                ToDo(task: "task1", category: self)
            ]
        }
    }
}

// Mark: 自作の型をUserDefalutに保存する時、Codableに準拠している必要がある
extension ToDo: Codable {
    enum CodingKeys: CodingKey {
        case task
        case category
        case identifier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        task = try container.decode(String.self, forKey: .task)
        category = try container.decode(Category.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(task, forKey: .task)
        try container.encode(category, forKey: .category)
        try container.encode(identifier, forKey: .identifier)
    }
}
