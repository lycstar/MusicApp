//
//  Api.swift
//  MusicApp
//
//  Created by lycstar on 2023/2/3.
//

import Foundation

struct Api {
    static var cookie = ""
    static var host: String = "http://localhost:3000"
    static var serverHost = "http://101.201.68.124:3000"

    static func createQrcodeKey() async -> String? {
        var key: String?
        do {
            var url = URLComponents(string: "\(serverHost)/login/qr/key")!
            url.queryItems = [
                URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
            ]
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
            let dataMap = map["data"] as! Dictionary<String, Any>
            key = dataMap["unikey"] as! String?
        } catch {
            print("Error decoding: ", error)
        }
        return key;
    }

    static func createQrcode(key: String?) async -> String? {
        var qrimg: String?
        do {
            var url = URLComponents(string: "\(serverHost)/login/qr/create")!
            url.queryItems = [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "qrimg", value: "true"),
                URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
            ]
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
            let dataMap = map["data"] as! Dictionary<String, Any>
            qrimg = dataMap["qrimg"] as! String?
        } catch let error {
            print("Error decoding: ", error)
        }
        return qrimg;
    }

    static func checkQrcode(key: String?, result: @escaping (Int?, String?) -> Void) {
        var url = URLComponents(string: "\(serverHost)/login/qr/check")!
        url.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
        ]
        let urlRequest = URLRequest(url: url.url!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                return;
            }
            do {
                let map = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                let code = map["code"] as! Int?
                let cookie = map["cookie"] as! String?
                result(code, cookie)
            } catch {
            }
        }
        task.resume()
    }

    static func fetchUserInfo() async -> Int? {
        var uid: Int?
        do {
            var url = URLComponents(string: "\(serverHost)/user/account")!
            url.queryItems = [
                URLQueryItem(name: "cookie", value: cookie),
                URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
            ]
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
            let accountMap = map["account"] as! Dictionary<String, Any>
            uid = accountMap["id"] as! Int?
        } catch let error {
            print("Error decoding: ", error)
        }
        return uid;
    }

    static func fetchLoveId() async -> Int? {
        var playlistId: Int?
        let uid = await fetchUserInfo()
        if (uid != nil) {
            do {
                var url = URLComponents(string: "\(serverHost)/user/playlist")!
                url.queryItems = [
                    URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
                    URLQueryItem(name: "cookie", value: cookie),
                    URLQueryItem(name: "uid", value: String(uid!)),
                ]
                let (data, _) = try await URLSession.shared.data(from: url.url!)
                let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                let accountMap = map["playlist"] as! Array<Dictionary<String, Any>>
                playlistId = accountMap.first!["id"] as! Int?
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        return playlistId
    }

    static func fetchPlaylist() async -> Playlist? {
        let playlistId = await fetchLoveId()
        if (playlistId != nil) {
            do {
                var url = URLComponents(string: "\(serverHost)/playlist/detail")!
                url.queryItems = [
                    URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
                    URLQueryItem(name: "cookie", value: cookie),
                    URLQueryItem(name: "id", value: String(playlistId!)),
//                                        URLQueryItem(name: "id", value: String(3215936658)),
                ]
                let (data, _) = try await URLSession.shared.data(from: url.url!)
                let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                let playlistMap = map["playlist"] as! Dictionary<String, Any>
                return try JSONDecoder().decode(Playlist.self, from: try JSONSerialization.data(withJSONObject: playlistMap))
            } catch let error {
                print("Error decoding: ", error)
            }

        }
        return nil
    }

    static func fetchMusicUrl(id: Int) async -> String? {
        do {
            var url = URLComponents(string: "\(serverHost)/song/url")!
            url.queryItems = [
                URLQueryItem(name: "timestamp", value: Date().currentTimeMillis()),
                URLQueryItem(name: "cookie", value: cookie),
                URLQueryItem(name: "id", value: String(id)),
            ]
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            let map = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
            let dataMap = map["data"] as! Array<Dictionary<String, Any>>
            if (dataMap.first != nil) {
                return dataMap.first!["url"] as! String?
            }
        } catch let error {
            print("Error decoding: ", error)
        }
        return nil
    }

    static func fetchSmallImage(url: String?) -> String {
        if (url == nil) {
            return ""
        }
        return url!
//        return "\(url!)?param=400y400"
    }
}
