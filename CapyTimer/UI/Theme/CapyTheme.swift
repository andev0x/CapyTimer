//
//  CapyTheme.swift
//  CapyTimer
//
//  A lightweight design system for consistent styling.
//

import SwiftUI

// MARK: - Palette
struct CapyColors {
    static let accent = Color.accentColor
    static let card = Color(nsColor: .windowBackgroundColor)
    static let border = Color.gray.opacity(0.25)
    static let subtleText = Color.secondary
}

// MARK: - Components
struct Card<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(CapyColors.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(CapyColors.border, lineWidth: 1)
        )
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    var progress: Double   // 0.0 ... 1.0
    var lineWidth: CGFloat = 8
    var body: some View {
        ZStack {
            Circle()
                .stroke(CapyColors.border, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(CapyColors.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .animation(.easeInOut(duration: 0.3), value: progress)
    }
}

// MARK: - Text Field Style
struct CompactTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .textFieldStyle(.roundedBorder)
            .frame(height: 26)
    }
}


