//
//  ContentView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/04/2021.
//

import SwiftUI

struct ContentView<T : LobbyViewModelProtocol>: View {
    @EnvironmentObject var lobbyVM : T
    //var homeVM = HomeVM()
    var routeVM = RouteVM()

    var body: some View {
        if lobbyVM.isOk {
            PageRoute<RouteVM>()
                .environmentObject(routeVM)
            
        }
        else {
            LobbyView<LobbyVM>()
                .environmentObject(lobbyVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<LobbyVMUnitTest>()
            .environmentObject(LobbyVMUnitTest(isOk: true, isProcessing: false))
    }
}
