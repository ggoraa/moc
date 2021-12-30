//
//  LoginView.swift
//  Moc
//
//  Created by Егор Яковенко on 25.12.2021.
//

import SwiftUI
import TDLibKit

private enum OpenedScreen {
	case phoneNumber
	case code
	case termsOfService
}

struct LoginView: View {
	func stepView(number: Int, text: String) -> some View {
		HStack {
			ZStack {
				Color.blue
					.clipShape(RoundedRectangle(cornerRadius: 10))
				Text("\(number)")
					.foregroundColor(.white)
			}
				.frame(width: 20, height: 20)
			Text(try! AttributedString(markdown: text))
			Spacer()
		}
	}

	@State private var phoneNumber: String = ""
	@Environment(\.tdApi) private var tdApi: TdApi
	@Environment(\.presentationMode) private var presentationMode
	@State private var code = ""
	@State private var openedScreen = OpenedScreen.phoneNumber

	//			VStack(spacing: 12) {
	//				Text("Fast login using a QR code")
	//					.font(.title)
	//					.padding(.top)
	//				// QR Code
	//				Rectangle()
	//					.frame(width: 150, height: 150)
	//					.clipShape(RoundedRectangle(cornerRadius: 20))
	//				VStack {
	//					stepView(number: 1, text: "Open Telegram from your phone")
	//					stepView(number: 2, text: "Open **Settings** -> **Devices** -> **Connect device**.")
	//					stepView(number: 3, text: "To confirm, point your phone camera to the QR code.")
	//				}
	//				.frame(width: 200)
	//				.padding()
	//			}.padding()

	var body: some View {
		VStack {
			switch openedScreen {
				case .phoneNumber:
					Text("Enter your phone number")
					TextField("Phone number", text: $phoneNumber)
						.onSubmit {
						try! tdApi.setAuthenticationPhoneNumber(phoneNumber: phoneNumber, settings: nil, completion: { data in
							openedScreen = .code
						})
							
					}
				case .code:
					Text("Enter the code")
					TextField("Code", text: $code)
					.onSubmit {
						Task(priority: .medium) {
							try! await tdApi.checkAuthenticationCode(code: code)
							openedScreen = .termsOfService
						}
					}
				case .termsOfService:
					Text("Accept the Terms of Service")
					
			}

		}
		.onReceive(NotificationCenter.default.publisher(for: Notification.Name("AuthorizationSuccessful"), object: nil)) { output in
			presentationMode.wrappedValue.dismiss()
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
