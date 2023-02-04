//
//  Extensions.swift
//  MusicApp
//
//  Created by lycstar on 2023/2/4.
//

import Foundation
import SwiftUI


extension Date {
    func currentTimeMillis() -> String {
        return String(describing: Int64(self.timeIntervalSince1970 * 1000))
    }
}

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else {
            return nil
        }
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        self = Image(uiImage: uiImage)
    }
}
