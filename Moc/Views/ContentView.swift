//
//  ContentView.swift
//  Moc
//
//  Created by Егор Яковенко on 24.12.2021.
//

import Backend
import Logging
import Resolver
import SPSafeSymbols
import SwiftUI
import Utils
import TDLibKit

struct ContentView: View {
    private let logger = Logging.Logger(label: "ContentView")

    @State private var selectedFolder: Int = 0
    @State private var selectedChat: Int? = 0
    @State private var isArchiveChatListOpen = false
    @State private var showingLoginScreen = false
    @State private var selectedTab = 0

    @InjectedObject private var chatViewModel: ChatViewModel

    @InjectedObject private var mainViewModel: MainViewModel
    @StateObject private var viewRouter = ViewRouter()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(0 ..< 10, content: { _ in
                            FolderItemView()
                        }).frame(alignment: .center)
                    }
                    .frame(minWidth: 70)
                    VStack {
                        SearchField()
                            .padding([.leading, .bottom, .trailing], 15.0)
                        List(
                            isArchiveChatListOpen
                                ? mainViewModel.archiveChatList
                                : mainViewModel.mainChatList
                        ) { chat in
                            ChatItemView(chat: chat)
                                .frame(height: 52)
                                .onTapGesture {
                                    Task {
                                        do {
                                            try await chatViewModel.update(chat: chat)
                                        } catch {
                                            logger.error("Error in \(error.localizedDescription)")
                                        }
                                    }
                                    viewRouter.openedChat = chat
                                    viewRouter.currentView = .chat
                                }
                                .padding(6)
                                .background(
                                    (viewRouter.currentView == .chat
                                        && viewRouter.openedChat! == chat)
                                        ? Color.accentColor.opacity(0.6)
                                        : nil
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .swipeActions {
                                    Button(role: .destructive) {
                                        logger.info("Pressed Delete button")
                                    } label: {
                                        Label("Delete chat", systemImage: SPSafeSymbol.trash.name)
                                    }
                                }
                        }
                        .frame(minWidth: 320)
                    }.toolbar {
                        ToolbarItem(placement: .status) {
                            Picker("", selection: $selectedTab) {
                                Image(.bubble.leftAndBubbleRight).tag(0)
                                Image(.phone.andWaveform).tag(1)
                                Image(.person._2).tag(2)
                            }.pickerStyle(.segmented)
                        }
                        ToolbarItem(placement: .status) {
                            Spacer()
                        }
                        ToolbarItem(placement: .status) {
                            Toggle(isOn: $isArchiveChatListOpen) {
                                Image(isArchiveChatListOpen ? .archivebox.fill : .archivebox)
                            }
                        }
                        ToolbarItem(placement: .status) {
                            // swiftlint:disable multiple_closures_with_trailing_closure
                            Button(action: { logger.info("Pressed add chat") }) {
                                Image(.square.andPencil)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)

            switch viewRouter.currentView {
            case .selectChat:
                VStack {
                    Image(.bubble.leftAndBubbleRight)
                        .font(.system(size: 96))
                        .foregroundColor(.gray)
                    Text("Open a chat or start a new one!")
                        .font(.largeTitle)
                        .foregroundStyle(Color.secondary)
                    Text("Pick any chat on the left sidebar, and have fun chatting!")
                        .foregroundStyle(Color.secondary)
                }
            case .chat:
                ChatView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showingLoginScreen) {
            LoginView()
                .frame(width: 400, height: 500)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
