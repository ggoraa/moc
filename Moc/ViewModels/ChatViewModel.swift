//
//  ChatViewModel.swift
//  Moc
//
//  Created by Егор Яковенко on 20.01.2022.
//

import Backend
import Combine
import Foundation
import Resolver
import Utils
import TDLibKit
import Algorithms
import SwiftUI

private enum Event {
    case updateNewMessage
}

class ChatViewModel: ObservableObject {
    @Injected private var service: ChatService
    
    var scrollView: NSScrollView?
    var scrollViewProxy: ScrollViewProxy?
    
    // MARK: - UI state

    @Published var inputMessage = ""
    @Published var isInspectorShown = false
    @Published var messages: [Message] = []

    @Published var chatID: Int64 = 0
    @Published var chatTitle = ""
    @Published var chatMemberCount: Int?
    @Published var chatPhoto: File?
    
    private var subscribers: [AnyCancellable] = []
    
    init() {
        subscribers.append(SystemUtils.ncPublisher(for: .updateNewMessage)
            .sink(receiveValue: updateNewMessage(notification:)))
//        subscribers.append(contentsOf: SystemUtils.ncPublisher(for: .update))
        
    }
    
    deinit {
        for subscriber in subscribers {
            subscriber.cancel()
        }
    }
    
    func updateNewMessage(notification: NCPO) {
        let tdMessage = (notification.object as? UpdateNewMessage)!.message
        guard tdMessage.chatId == chatID else { return }
        Task {
            let sender = try await self.service.getUser(byId: tdMessage.chatId)
            let message = Message(
                id: tdMessage.id,
                sender: MessageSender(
                    name: "\(sender.firstName) \(sender.lastName)",
                    type: .user,
                    id: sender.id),
                content: MessageContent(tdMessage.content),
                isOutgoing: tdMessage.isOutgoing,
                date: Date(timeIntervalSince1970: TimeInterval(tdMessage.date))
            )
            
            DispatchQueue.main.async {
                self.messages.append(message)
                self.scrollToEnd()
            }
        }
        
//            .chunked {
//                let firstDay = Calendar.current.dateComponents([.day], from: $0.date).day
//                let secondDay = Calendar.current.dateComponents([.day], from: $1.date).day
//                guard firstDay != nil else { false }
//                guard secondDay != nil else { false }
//
//                return firstDay! < secondDay!
//            }
    }
    
    func scrollToEnd() {
        scrollViewProxy?.scrollTo(messages.last?.id ?? 0)
    }
    
    func update(chat: Chat) async throws {
        service.set(chatId: chat.id)
        chatID = chat.id
        objectWillChange.send()
        chatTitle = chat.title
        let messageHistory: [Message] = try await service.messageHistory
            .asyncMap { tdMessage in
                switch tdMessage.senderId {
                    case let .messageSenderUser(user):
                        let user = try await self.service.getUser(byId: user.userId)
                        return Message(
                            id: tdMessage.id,
                            sender: .init(
                                name: "\(user.firstName) \(user.lastName)",
                                type: .user,
                                id: user.id
                            ),
                            content: MessageContent(tdMessage.content),
                            isOutgoing: tdMessage.isOutgoing,
                            date: Date(timeIntervalSince1970: Double(tdMessage.date))
                        )
                    case let .messageSenderChat(chat):
                        let chat = try await self.service.getChat(id: chat.chatId)
                        return Message(
                            id: tdMessage.id,
                            sender: .init(
                                name: chat.title,
                                type: .chat,
                                id: chat.id
                            ),
                            content: MessageContent(tdMessage.content),
                            isOutgoing: tdMessage.isOutgoing,
                            date: Date(timeIntervalSince1970: Double(tdMessage.date))
                        )
                }
            }
            .sorted { $0.id < $1.id }

        DispatchQueue.main.async {
            Task {
                self.objectWillChange.send()
                self.chatPhoto = try await self.service.chatPhoto
                self.chatMemberCount = try await self.service.chatMemberCount
            }
            self.objectWillChange.send()
            self.messages = messageHistory
            self.scrollToEnd()
        }
    }
    
    func sendMessage(_ message: String) {
        Task {
            try await service.sendMessage(message)
        }
    }

//        .onReceive(SystemUtils.ncPublisher(for: .updateNewMessage)) { notification in

//        }
}
