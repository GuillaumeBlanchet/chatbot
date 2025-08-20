//
//  ContentViewModel.swift
//  chatbot
//
//  Created by Guillaume on 2025-08-20.
//

//
//  ChatViewModel.swift
//  AccountabilityPartner
//
//  Created by Guillaume on 2025-08-18.
//

import SwiftUI
import ExyteChat
import OpenAI

@MainActor
class ChatViewModel: ObservableObject {
    
    private let openAI: OpenAI
    @Published var messages: [Message] = []
    
    init() {
        // TODO: store this api key in keychain:
        self.openAI = OpenAI(apiToken: "YOUR_OPENAI_API_KEY_HERE")

        let welcomeMessage = createMessage(userId: "bot", text: "Hey! What's up?")
        messages.append(welcomeMessage)
    }
    
    func send(draft: DraftMessage) {
        let userMessage = createMessage(userId: "user", text: draft.text, createdAt: draft.createdAt)
        messages.append(userMessage)
        
        // Create initial bot message for streaming
        let botMessageId = UUID().uuidString
        let botMessage = createMessage(messageId: botMessageId, userId: "bot", text: "thinking...", status: .sending)
        messages.append(botMessage)
        
        // Start OpenAI response
        Task {
            await streamOpenAIResponse(userText: draft.text, botMessageId: botMessageId)
        }
    }
    
    private func streamOpenAIResponse(userText: String, botMessageId: String) async {
        do {
            // Create conversation context with all messages
            var chatMessages: [ChatQuery.ChatCompletionMessageParam] = [
                .system(.init(content: .textContent("You're a cheerful chatbot who brings joy and humor to every conversation.")))
            ]
            
            // Add recent conversation history (last 10 messages to keep context manageable)
            let recentMessages = messages.suffix(10)
            for message in recentMessages {
                if message.user.isCurrentUser {
                    chatMessages.append(.user(.init(content: .string(message.text))))
                } else if message.id != botMessageId { // Don't include the message we're currently generating
                    chatMessages.append(.assistant(.init(content: .textContent(message.text))))
                }
            }
            
            let query = ChatQuery(
                // OpenAI MacPaw doesn't support gpt5_nano yet for streaming, so we use gpt4_1_nano
                messages: chatMessages, model: .gpt4_1_nano,
                temperature: 0.7,
                stream: true
            )
            
            var streamText = ""
            
            for try await result in openAI.chatsStream(query: query) {
                if let content = result.choices.first?.delta.content {
                    streamText += content
                    
                    // Update the bot message with accumulated text
                    if let messageIndex = messages.firstIndex(where: { $0.id == botMessageId }) {
                        var updatedMessage = messages[messageIndex]
                        updatedMessage.text = streamText
                        updatedMessage.status = .sent
                        messages[messageIndex] = updatedMessage
                    }
                }
            }
            
        } catch {
            print("Error streaming OpenAI response: \(error)")
            
            // Fallback to error message
            if let messageIndex = messages.firstIndex(where: { $0.id == botMessageId }) {
                var updatedMessage = messages[messageIndex]
                updatedMessage.text = "I'm having trouble connecting right now. Please try again in a moment. \n\n Error: \(error)"
                updatedMessage.status = .sent
                messages[messageIndex] = updatedMessage
            }
        }
    }
}

extension ChatViewModel {
    private func createMessage(
        messageId: String = UUID().uuidString,
        userId: String,
        text: String,
        status: Message.Status = .sent,
        createdAt: Date = Date()
    ) -> Message {
        let user = userId == "bot"
            ? User(id: "bot", name: "chatbot", avatarURL: nil, isCurrentUser: false)
            : User(id: "user", name: "You", avatarURL: nil, isCurrentUser: true)
        
        return Message(
            id: messageId,
            user: user,
            status: status,
            createdAt: createdAt,
            text: text
        )
    }
}
