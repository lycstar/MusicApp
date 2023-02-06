//
//	Playlist.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Playlist: Codable {

    let coverImgId: Int?
    let coverImgUrl: String?
    let createTime: Int?
    let creator: Creator?
    let description: String?
    let id: Int?
    let name: String?
    let trackCount: Int?
    let tracks: [Track]?
    let userId: Int?


    enum CodingKeys: String, CodingKey {
        case coverImgId = "coverImgId"
        case coverImgUrl = "coverImgUrl"
        case createTime = "createTime"
        case creator
        case description = "description"
        case id = "id"
        case name = "name"
        case trackCount = "trackCount"
        case tracks = "tracks"
        case userId = "userId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coverImgId = try values.decodeIfPresent(Int.self, forKey: .coverImgId)
        coverImgUrl = try values.decodeIfPresent(String.self, forKey: .coverImgUrl)
        createTime = try values.decodeIfPresent(Int.self, forKey: .createTime)
        creator = try Creator(from: decoder)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        trackCount = try values.decodeIfPresent(Int.self, forKey: .trackCount)
        tracks = try values.decodeIfPresent([Track].self, forKey: .tracks)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }


}
