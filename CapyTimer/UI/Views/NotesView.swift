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
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $notesManager.notes)
                .frame(height: 100)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(CapyColors.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(CapyColors.border, lineWidth: 1)
                )
        }
        .padding(.top, 2)
    }
}
