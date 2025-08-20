//
//  ViewModifiers.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
}

extension View {
    func cardModifier() -> some View {
        self.modifier(CardModifier())
    }
}
