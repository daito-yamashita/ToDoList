//
//  Item.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/20.
//

import UIKit

struct Item: Hashable {
    let todo: ToDo?
    let title: String
    var identifier = UUID()
    
    init(todo: ToDo? = nil, title: String) {
        self.todo = todo
        self.title = title
    }
}

extension Item: Codable {
    enum CodingKeys: CodingKey {
        case todo
        case title
        case identifier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todo = try container.decode(ToDo.self, forKey: .todo)
        title = try container.decode(String.self, forKey: .title)
        identifier = try container.decode(UUID.self, forKey: .identifier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(todo, forKey: .todo)
        try container.encode(title, forKey: .title)
        try container.encode(identifier, forKey: .identifier)
    }
}
