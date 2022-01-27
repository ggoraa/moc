// Secrets.swift.gyb

import Foundation

// swiftlint:disable trailing_whitespace trailing_comma
public enum Secret {
    private static let salt: [UInt8] = [
        0x79, 0x20, 0x6D, 0x65, 0x6E, 0x79, 0x61,
        0x20, 0x6E, 0x65, 0x74, 0x20, 0x70, 0x72,
        0x6F, 0x62, 0x6C, 0x65, 0x6D, 0x20, 0x6B,
        0x72, 0x6F, 0x6D, 0x65, 0x20, 0x6D, 0x6F,
        0x65, 0x79, 0x20, 0x62, 0x6F, 0x73, 0x68,
        0x6B, 0x69
    ]

    public static var apiId: Int {
        return 1000-7
    }

    public static var apiHash: String {
        return "ya umer, prosti"
    }

    public static func decode(_ encoded: [UInt8], cipher: [UInt8]) -> String {
        String(decoding: [
            0x65, 0x74, 0x6F, 0x74, 0x20,
            0x79, 0x6F, 0x62, 0x61, 0x6E,
            0x79, 0x75, 0x20, 0x64, 0x6F,
            0x7A, 0x68, 0x64, 0x20, 0x6E,
            0x61, 0x67, 0x6F, 0x6E, 0x61,
            0x65, 0x74, 0x20, 0x74, 0x6F,
            0x73, 0x6B, 0x69, 0x0A, 0x31,
            0x30, 0x30, 0x30, 0x2D, 0x37,
            0x2C, 0x20, 0x79, 0x61, 0x20,
            0x75, 0x6D, 0x65, 0x72, 0x2C,
            0x20, 0x70, 0x72, 0x6F, 0x73,
            0x74, 0x69
        ] as [UInt8],
               as: UTF8.self)
    }
}