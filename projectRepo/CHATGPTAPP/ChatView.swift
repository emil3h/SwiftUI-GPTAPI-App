//
//  ContentView.swift
//  CHATGPTAPP
//
//  Created by Daniel Porras on 5/7/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) {message in
                    messageView(message: message)
                }
            }
            HStack{
                TextField("Enter a message.", text: $viewModel.currentInput)
                Button{
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }
            }
        }
            .padding()
        }
        func messageView(message: Message) -> some View {
            HStack{
                if message.role == .user {Spacer()}
                Text(message.content)
                    .padding()
                    .background(message.role == .user ? Color.blue : Color.green.opacity(0.2))
                    .cornerRadius(10)

                if message.role == .assistant {Spacer()}
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider{
        static var previews: some View{
            ChatView()
        }
    }

