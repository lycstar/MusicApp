//
//	Creator.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Creator: Codable {

    let avatarUrl: String?
    let backgroundUrl: String?
    let gender: Int?
    let nickname: String?
    let signature: String?
    let userId: Int?


    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatarUrl"
        case backgroundUrl = "backgroundUrl"
        case gender = "gender"
        case nickname = "nickname"
        case signature = "signature"
        case userId = "userId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        backgroundUrl = try values.decodeIfPresent(String.self, forKey: .backgroundUrl)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        nickname = try values.decodeIfPresent(String.self, forKey: .nickname)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }


}