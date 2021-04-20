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
    let identifier = UUID()
    
    init(todo: ToDo? = nil, title: String) {
        self.todo = todo
        self.title = title
    }
}
