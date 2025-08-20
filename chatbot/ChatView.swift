//
//  ChatView.swift
//  chatbot
//
//  Created by Guillaume on 2025-08-20.
//

import SwiftUI
import ExyteChat

struct ChatGoalView: View {
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some View {
        ChatView(messages: chatViewModel.messages) { draft in
            chatViewModel.send(draft: draft)
        }
        .setAvailableInputs([AvailableInputType.text])
        .navigationTitle("Together Toward Your Goal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChatGoalView()
    }
}
