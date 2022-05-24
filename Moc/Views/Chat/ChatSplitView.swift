//
//  ChatSplitView.swift
//  Moc
//
//  Created by Егор Яковенко on 07.01.2022.
//

import SwiftUI

struct ChatSplitView<Left: View, Right: View>: View {
    var isRightViewVisible: Bool = true
    @ViewBuilder var leftView: () -> Left
    @ViewBuilder var rightView: () -> Right

    var body: some View {
        HSplitView {
            leftView()
            rightView()
                .frame(
                    minWidth: isRightViewVisible ? 316 : 0,
                    idealWidth: isRightViewVisible ? 316 : 0,
                    maxWidth: isRightViewVisible ? nil : 0
                )
        }
    }
}

struct ChatSplitView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSplitView {
            Text("Left")
        } rightView: {
            Text("Right")
        }
    }
}
