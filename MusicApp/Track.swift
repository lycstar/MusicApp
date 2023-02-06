//
//	Track.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Track: Codable {

    let al: Al?
    let ar: [Ar]?
    let dt: Int?
    let fee: Int?
    let id: Int?
    let mv: Int?
    let name: String?
    let publishTime: Int?


    enum CodingKeys: String, CodingKey {
        case al
        case ar = "ar"
        case dt = "dt"
        case fee = "fee"
        case id = "id"
        case mv = "mv"
        case name = "name"
        case publishTime = "publishTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        al = try values.decodeIfPresent(Al.self, forKey: .al)
        ar = try values.decodeIfPresent([Ar].self, forKey: .ar)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        fee = try values.decodeIfPresent(Int.self, forKey: .fee)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        mv = try values.decodeIfPresent(Int.self, forKey: .mv)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        publishTime = try values.decodeIfPresent(Int.self, forKey: .publishTime)
    }


}
