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
        VStack(alignment: .leading) {
            Text("Todo List")
                .font(.headline)
            
            ForEach(todoManager.todos) { todo in
                HStack {
                    Button(action: { todoManager.toggle(todo.id) }) {
                        Image(systemName: todo.done ? "checkmark.square" : "square")
                    }
                    .buttonStyle(.plain)
                    
                    Text(todo.title)
                        .strikethrough(todo.done)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        todoManager.remove(todo.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.plain)
                }
            }
            
            HStack {
                TextField("New task...", text: $newTask, onCommit: {
                    todoManager.add(newTask)
                    newTask = ""
                })
                Button("Add") {
                    todoManager.add(newTask)
                    newTask = ""
                }
            }
        }
        .padding(.top, 5)
    }
}
