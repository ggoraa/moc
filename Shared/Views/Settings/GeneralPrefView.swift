//
//  GeneralPrefView.swift
//  Moc
//
//  Created by Егор Яковенко on 12.01.2022.
//

import SwiftUI
import Defaults
import Utilities

extension Int64: Identifiable {
    public var id: Int64 {
        return self
    }
}

struct GeneralPrefView: View {
    @State private var isNewChatShortcutSheetOpen = false
    @State private var chatId: Int64 = 0
    @State private var chatShortcutsSelection = Set<Int64>()

    @Default(.chatShortcuts) private var chatShortcuts
        
    var body: some View {
        TabView {
            Text("To be implemented")
                .tabItem {
                    Text("General")
                }
            HStack(spacing: 16) {
                VStack {
                    Text("Chat Shortcuts")
                        .font(.largeTitle)
                    Text("Save chats to app's menubar for easy access from any place in Moc.")
                    Divider()
                    Form {
                        Section {
                            Defaults.Toggle("Use \"Saved Messages\" shortcut", key: .useSavedMessagesShortcut)
                        } footer: {
                            Text("""
                            If enabled, will use the ⌘0 shortcut. If \
                            disabled, the ⌘0 shortcut will be used by \
                            the first shortcut in the list.
                            """)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer()
                }
                .frame(width: 300)
                if chatShortcuts.isEmpty {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "command")
                                .font(.system(size: 76))
                                .foregroundColor(.gray)
                            Text("You have not created any shortcuts :(")
                                .font(.title)
                                .foregroundStyle(Color.secondary)
                            Text("Click the \"Create\" button down below to create a new one!")
                                .foregroundStyle(Color.secondary)
                            Button("Create") {
                                isNewChatShortcutSheetOpen = true
                            }
                            .padding()
                            .buttonStyle(.bordered)
                        }
                        .frame(maxWidth: 300)
                        .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    VStack(alignment: .leading) {
                        List(chatShortcuts, selection: $chatShortcutsSelection) { chatId in
                            HStack {
                                CompactChatItemView(chatId: chatId)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    chatShortcuts.removeAll(where: { $0 == chatId })
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                        #if os(macOS)
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        #endif
                        HStack {
                            Button {
                                isNewChatShortcutSheetOpen = true
                            } label: {
                                Image(systemName: "plus")
                            }
                            Divider()
                                .frame(maxHeight: 10)
                            Button {
                                for shortcut in chatShortcutsSelection {
                                    chatShortcuts.removeAll(where: { $0 == shortcut })
                                }
                            } label: {
                                Image(systemName: "minus")
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .frame(minWidth: 250, minHeight: 300)
            .padding(8)
            .sheet(isPresented: $isNewChatShortcutSheetOpen) {
                VStack(spacing: 8) {
                    Button {
                        isNewChatShortcutSheetOpen = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                    .hTrailing()
                    Text("""
                        Chat picker is in development, will be done in Stage 3
                        Please insert the chat ID instead, you can find it \
                        in the chat inspector with "Show developer info" \
                        enabled
                        """)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    TextField("Chat ID", value: $chatId, formatter: NumberFormatter())
                        .onSubmit {
                            if chatId != 0 {
                                if !chatShortcuts.contains(chatId) {
                                    chatShortcuts.append(chatId)
                                    isNewChatShortcutSheetOpen = false
                                    self.chatId = 0
                                }
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                }
                .frame(maxWidth: 200, maxHeight: 300)
                .padding()
            }
            .tabItem {
                Text("Chat Shortcuts")
            }
            VStack {
                Form {
                    Section {
                        Defaults.Toggle("Show developer info", key: .showDeveloperInfo)
                    } footer: {
                        Text("""
                    When enabled, Moc will show additional data in the \
                    chat inspector like the chat/user ID.
                    """)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
            }
            .tabItem {
                Text("Advanced")
            }
        }
        .tabViewStyle(.automatic)
        .padding()
    }
}

struct GeneralPrefView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPrefView()
    }
}
