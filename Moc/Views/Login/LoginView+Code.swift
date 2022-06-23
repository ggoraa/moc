//
//  LoginView+Code.swift
//  Moc
//
//  Created by Егор Яковенко on 23.06.2022.
//

import SwiftUI
import TDLibKit

extension LoginView {
    var codeView: some View {
        VStack {
            Text("Enter the code")
                .font(.title)
            TextField("Code", text: $code)
                .onSubmit {
                    Task {
                        do {
                            withAnimation { showLoadingSpinner = true }
                            try await service.checkAuth(code: code)
                            withAnimation { showLoadingSpinner = false }
                        } catch {
                            showErrorAlert = true
                        }
                    }
                }
                .frame(width: 156)
                .textFieldStyle(.roundedBorder)
            
//            Button {
//                Task {
//                    do {
//                        try await service.resendAuthCode()
//                    } catch {
//                        showErrorAlert = true
//                        errorAlertMessage = (error as! TDLibKit.Error).message
//                    }
//                }
//            } label: {
//                Label("Request SMS code", systemImage: "text.bubble")
//            }
//            .buttonStyle(.plain)
            if showLoadingSpinner {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}
