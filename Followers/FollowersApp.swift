//
//  FollowersApp.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/04/2021.
//

import SwiftUI

@main
struct FollowersApp: App {
    var lobbyVM = LobbyVM()
    var body: some Scene {
        WindowGroup {
            ContentView<LobbyVM>()
                .environmentObject(lobbyVM)
                //.environmentObject(funcList)
                //.environmentObject(modelData)
        }
    }
}
