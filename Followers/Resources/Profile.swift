//
//  Profile.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 03/05/2021.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotification = true
    var seasonPhoto = Season.winter
    var goalDate = Date()
    
    static let `default` = Profile(username: "Ahaha")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
        
        var id: String {self.rawValue}
    }
}
