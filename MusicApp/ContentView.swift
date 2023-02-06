//
//  ContentView.swift
//  MusicApp
//
//  Created by lycstar on 2023/2/3.
//

import SwiftUI

class HomeModel: ObservableObject {


    @Published var login: Bool = false

    init() {
        checkLoginStatu()
    }

    func checkLoginStatu() {
        let cookie = UserDefaults.standard.object(forKey: "cookie") as? String ?? ""
        Api.cookie = cookie
        self.login = !cookie.isEmpty
    }
}


struct ContentView: View {

    @ObservedObject var homeModel = HomeModel()

    var body: some View {
        if homeModel.login {
            PlaylistView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
