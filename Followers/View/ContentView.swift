//
//  ContentView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/04/2021.
//

import SwiftUI

struct ContentView<T: LobbyViewModelProtocol>: View {
    @EnvironmentObject var lobbyVM : T
    var funcList = Features()
    

    var body: some View {
        if lobbyVM.isOk {
            HomePage<HomeVM>()
        }
        else {
            LobbyView<T>()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<LobbyVMUnitTest>()
            .environmentObject(LobbyVMUnitTest(isOk: false, isProcessing: false))
    }
}
