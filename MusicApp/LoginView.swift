//
//  LoginView.swift
//  MusicApp
//
//  Created by lycstar on 2023/2/3.
//

import SwiftUI

class LoginModel: ObservableObject {

    @Published var base64Data: String?

    @Published var code: Int?

    @Published var success: Bool = false

    init() {
        fetchKeyAndQrcode()
    }

    func fetchKeyAndQrcode() {
        DispatchQueue.main.async {
            Task {
                let key = await Api.createQrcodeKey()
                self.base64Data = await Api.createQrcode(key: key)
                self.base64Data = self.base64Data?.replacingOccurrences(of: "data:image/png;base64,", with: "")
                self.checkCode(key: key)
            }
        }
    }

    func checkCode(key: String?) {
        let checkTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            Api.checkQrcode(key: key, result: { code, cookie in
                DispatchQueue.main.async {
                    self.code = code
                }
                if (code == 800) {
                    //过期
                    if (timer.isValid) {
                        timer.invalidate()
                    }
                    self.fetchKeyAndQrcode()
                } else if (code == 801) {
                    //等待扫码

                } else if (code == 802) {
                    //待确认

                } else if (code == 803) {
                    //登录成功
                    if (timer.isValid) {
                        timer.invalidate()
                    }
                    DispatchQueue.main.async {
                        self.success = true
                        UserDefaults.standard.set(cookie, forKey: "cookie")
                        Api.cookie = cookie ?? ""
                    }
                }
            })
        }
        RunLoop.current.add(checkTimer, forMode: .common)
    }
}


struct LoginView: View {

    @ObservedObject var loginModel = LoginModel()

    var body: some View {
        NavigationView {

            ScrollView {
                VStack {
                    Text("扫码登录").padding(.top, 100).font(.title)
                    if (loginModel.base64Data == nil) {
                        Spacer().frame(height: 235)
                    } else {
                        if (loginModel.code == 802) {
                            Image("confirm").frame(height: 200).shadow(radius: 4).scaledToFit().transition(AnyTransition.scale.animation(.easeInOut(duration: 0.35))).padding(.top, 10)
                        } else {
                            Image(base64String: loginModel.base64Data!).frame(width: 200, height: 200).shadow(radius: 4).scaledToFit().transition(AnyTransition.scale.animation(.easeInOut(duration: 0.35))).padding(.top, 10)
                        }
                    }
                    if (loginModel.code == 802) {
                        Text("请在手机上确认登录").padding(.top, 20)
                    } else {
                        Text("使用网易云音乐App扫码登录").padding(.top, 20)
                    }
                }
            }
                    .fullScreenCover(isPresented: $loginModel.success, content: {
                        PlaylistView()
                    })
                    .navigationBarTitle(Text("登录")
                            , displayMode: .large)
        }
    }
}
