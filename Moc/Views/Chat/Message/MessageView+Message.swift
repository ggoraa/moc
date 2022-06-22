//
//  MessageView+Message.swift
//  Moc
//
//  Created by Егор Яковенко on 21.06.2022.
//

import SwiftUI
import TDLibKit
import Utilities

extension MessageView {
    func makeMessage<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> some View {
        HStack(alignment: .bottom, spacing: nil) {
            if message.first!.isOutgoing { Spacer() }
            if !message.first!.isOutgoing {
                Group {
                    if senderPhotoFileID != nil {
                        AsyncTdImage(id: senderPhotoFileID!) { image in
                            image
                                .resizable()
                        } placeholder: {
                            avatarPlaceholder
                        }
                    } else {
                        avatarPlaceholder
                    }
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .padding(.leading, 4)
            }
            makeMessageBubble(isOutgoing: message.first!.isOutgoing) {
                content()
            }
            .frame(maxWidth: 350, alignment: message.first!.isOutgoing ? .trailing : .leading)
            if !message.first!.isOutgoing { Spacer() }
        }
        .onReceive(SystemUtils.ncPublisher(for: .updateFile)) { notification in
            let update = notification.object as! UpdateFile
            
            if update.file.id == senderPhotoFileID {
                senderPhotoFileID = update.file.id
            }
        }
        .onAppear {
            Task {
                switch message.first!.sender.type {
                    case .user:
                        let user = try await tdApi.getUser(userId: message.first!.sender.id)
                        senderPhotoFileID = user.profilePhoto?.small.id
                    case .chat:
                        let chat = try await tdApi.getChat(chatId: message.first!.sender.id)
                        senderPhotoFileID = chat.photo?.small.id
                }
            }
        }
    }
}