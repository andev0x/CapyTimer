//
//  TodoView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var todoManager: TodoManager
    @State private var newTask = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(todoManager.todos) { todo in
                HStack(spacing: 8) {
                    Button(action: { todoManager.toggle(todo.id) }) {
                        Image(systemName: todo.done ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(todo.done ? .accentColor : .secondary)
                    }
                    .buttonStyle(.plain)
                    
                    Text(todo.title)
                        .strikethrough(todo.done)
                        .foregroundColor(todo.done ? .secondary : .primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        todoManager.remove(todo.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            
            HStack(spacing: 8) {
                TextField("New task...", text: $newTask, onCommit: addTask)
                    .textFieldStyle(CompactTextFieldStyle())
                Button("Add", action: addTask)
                    .buttonStyle(.bordered)
            }
        }
        .padding(.top, 2)
    }
    
    private func addTask() {
        let trimmed = newTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        todoManager.add(trimmed)
        newTask = ""
    }
}
