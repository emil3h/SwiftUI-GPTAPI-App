//
//  ChatViewModel.swift
//  CHATGPTAPP
//
//  Created by Daniel Porras on 5/7/24.
//

import Foundation
extension ChatView{
    class ViewModel: ObservableObject{
        @Published var messages: [Message] = [Message(id: UUID(), role: .system, content: "Your assistance is requested solely for my journey in mastering the Swift programming language. While I acknowledge your proficiency in other programming languages, I kindly ask that all responses be tailored exclusively to Swift-related inquiries. Please refrain from offering advice or examples in any other programming language. Thank you for your understanding and cooperation in facilitating my Swift learning experience.", createAt: Date())]
        
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        func sendMessage(){
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("Had no received message")
                    return
                }
                
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run{
                    messages.append(receivedMessage)
                }
            }
            
        }
    }
}
struct Message: Decodable{
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
