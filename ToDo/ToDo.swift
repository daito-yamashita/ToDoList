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
    let identifier = UUID()
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
