//
//	Ar.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Ar : Codable {

	let id : Int?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}


}