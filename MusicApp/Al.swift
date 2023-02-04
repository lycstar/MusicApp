//
//	Al.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Al : Codable {

	let id : Int?
	let name : String?
	let pic : Int?
	let picUrl : String?


	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case pic = "pic"
		case picUrl = "picUrl"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		pic = try values.decodeIfPresent(Int.self, forKey: .pic)
		picUrl = try values.decodeIfPresent(String.self, forKey: .picUrl)
	}


}