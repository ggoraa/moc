//
//  MockChatService.swift
//
//
//  Created by Егор Яковенко on 18.01.2022.
//

import Resolver
import TDLibKit
import Foundation

// swiftlint:disable function_body_length
public class MockChatService: ChatService {
    public func getMessage(by id: Int64) async throws -> TDLibKit.Message {
        return Message(
            authorSignature: "",
            canBeDeletedForAllUsers: false,
            canBeDeletedOnlyForSelf: false,
            canBeEdited: false,
            canBeForwarded: false,
            canBeSaved: false,
            canGetAddedReactions: false,
            canGetMediaTimestampLinks: false,
            canGetMessageThread: false,
            canGetStatistics: false,
            canGetViewers: false,
            chatId: 0,
            containsUnreadMention: false,
            content: .messageText(.init(text: .init(entities: [], text: ""), webPage: nil)),
            date: 0,
            editDate: 0,
            forwardInfo: nil,
            hasTimestampedMedia: false,
            id: 0,
            interactionInfo: nil,
            isChannelPost: false,
            isOutgoing: false,
            isPinned: false,
            mediaAlbumId: 0,
            messageThreadId: 0,
            replyInChatId: 0,
            replyMarkup: nil,
            replyToMessageId: 0,
            restrictionReason: "",
            schedulingState: nil,
            senderId: .messageSenderChat(.init(chatId: 0)),
            sendingState: nil,
            ttl: 0,
            ttlExpiresIn: 0,
            unreadReactions: [],
            viaBotUserId: 0)
    }
    
    public func sendMedia(_ url: URL, caption: String) async throws {
        
    }
    
    public func sendAlbum(_ urls: [URL], caption: String) async throws {
        
    }
    
    public var isChannel: Bool = false
    
    public func setAction(_ action: ChatAction) async throws {
        
    }
    
    public func sendMessage(_ message: String) async throws {
        
    }
    
    public var chatPhoto: File?
    
    public func getUser(by id: Int64) async throws -> User {
        User(
            firstName: "First",
            haveAccess: true,
            id: id,
            isContact: true,
            isFake: false,
            isMutualContact: true,
            isScam: false,
            isSupport: true,
            isVerified: true,
            languageCode: "UA",
            lastName: "Last",
            phoneNumber: "phone",
            profilePhoto: nil,
            restrictionReason: "",
            status: .userStatusEmpty,
            type: .userTypeRegular,
            username: "username"
        )
    }

    public func getChat(by id: Int64) async throws -> Chat {
        Chat(
            actionBar: nil,
            availableReactions: [],
            canBeDeletedForAllUsers: true,
            canBeDeletedOnlyForSelf: true,
            canBeReported: true,
            clientData: "",
            defaultDisableNotification: true,
            draftMessage: nil,
            hasProtectedContent: false,
            hasScheduledMessages: false,
            id: id,
            isBlocked: false,
            isMarkedAsUnread: true,
            lastMessage: nil,
            lastReadInboxMessageId: 0,
            lastReadOutboxMessageId: 0,
            messageSenderId: nil,
            messageTtl: 0,
            notificationSettings: .init(
                disableMentionNotifications: true,
                disablePinnedMessageNotifications: true,
                muteFor: 0,
                showPreview: false,
                soundId: 0,
                useDefaultDisableMentionNotifications: false,
                useDefaultDisablePinnedMessageNotifications: false,
                useDefaultMuteFor: false,
                useDefaultShowPreview: false,
                useDefaultSound: false
            ),
            pendingJoinRequests: nil,
            permissions: .init(
                canAddWebPagePreviews: false,
                canChangeInfo: false,
                canInviteUsers: false,
                canPinMessages: false,
                canSendMediaMessages: false,
                canSendMessages: false,
                canSendOtherMessages: false,
                canSendPolls: true
            ),
            photo: nil,
            positions: [],
            replyMarkupMessageId: 0,
            themeName: "",
            title: "Ayy",
            type: .chatTypePrivate(.init(userId: 0)),
            unreadCount: 0,
            unreadMentionCount: 0,
            unreadReactionCount: 0,
            videoChat: .init(
                defaultParticipantId: nil,
                groupCallId: 0,
                hasParticipants: false
            )
        )
    }

    public init() {}
    public var messageHistory: [Message] = []

    public func getMessageSenderName(_: MessageSender) throws -> String {
        "Name"
    }

    public var draftMessage: DraftMessage?

    public func set(draft _: DraftMessage?) async throws {}

    public var chatId: Int64? = 0

    public var chatTitle: String = "Ninjas from the Reeds"

    public var chatType: ChatType = .chatTypeSupergroup(.init(isChannel: false, supergroupId: 0))

    public var chatMemberCount: Int? = 20

    public var protected: Bool = false

    public var blocked: Bool = false

    public func set(chatId _: Int64) {}

    public func set(protected _: Bool) async throws {}

    public func set(blocked _: Bool) async throws {}

    public func set(chatTitle _: String) async throws {}
}
