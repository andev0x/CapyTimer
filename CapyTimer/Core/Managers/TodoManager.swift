//
//  TodoManager.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var done: Bool = false
}

class TodoManager: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    func add(_ title: String) {
        guard !title.isEmpty else { return }
        todos.append(TodoItem(title: title))
    }
    
    func toggle(_ id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].done.toggle()
        }
    }
    
    func remove(_ id: UUID) {
        todos.removeAll { $0.id == id }
    }
}
