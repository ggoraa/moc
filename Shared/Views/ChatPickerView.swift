//
//  ChatPickerView.swift
//  Moc
//
//  Created by Егор Яковенко on 02.06.2022.
//

import SwiftUI

struct ChatPickerView: View {
    var body: some View {
        VStack {
            SearchField()
                .controlSize(.large)
            List {
                
            }
        }
    }
}

struct ChatPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChatPickerView()
    }
}
