//
//  NotesView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var notesManager: NotesManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Notes")
                .font(.headline)
            TextEditor(text: $notesManager.notes)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.top, 5)
    }
}
