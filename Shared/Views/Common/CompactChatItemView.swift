//
//  CompactChatItemView.swift
//  Moc
//
//  Created by Егор Яковенко on 08.08.2022.
//

import SwiftUI
import TDLibKit

struct CompactChatItemView: View {
    let chatId: Int64
    
    @State private var chat: Chat?
    
    @ViewBuilder
    var body: some View {
        Group {
            if let chat {
                switch chat.type {
                    case .secret: Image(systemName: "lock")
                    case .private: Image(systemName: "person")
                    case .basicGroup: Image(systemName: "person.2")
                    case .supergroup: Image(systemName: "person.2.fill")
                }
                Text(chat.title)
            } else {
                Text(String(chatId))
//                ProgressView()
            }
        }
        .task {
            do {
                chat = try await TdApi.shared[0].getChat(chatId: chatId)
            } catch {
                print(error)
            }
        }
    }
}
