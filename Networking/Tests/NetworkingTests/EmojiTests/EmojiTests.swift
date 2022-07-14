//
//  EmojiTests.swift
//
//
//  Created by DariaMikots on 08.07.2022.
//
@testable import Networking
import XCTest

final class EmojiTests: XCTestCase {
    
    func testEmoji() async throws {
        let serviceMock = EmojiServiceMock()
        let emojies = try await serviceMock.getEmoji(
            "smile",
            "100"
        )
        XCTAssertEqual(
            emojies.subCategories[0].emoji,
            "🍼"
        )
        let favoritEmoji = try await serviceMock.getFavorite()
        XCTAssertEqual(
            favoritEmoji.subCategories[0].emoji,
            "😻"
        )
    }
}
