//
//  LobbyView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct LobbyView<T: LobbyViewModelProtocol>: View {
    @EnvironmentObject private var lobbyVM : T
    var body: some View {
        VStack{
            if !lobbyVM.isProcessing{
                IconButton(name: "GO", action: startLogin)
            }
            else {
                IconTextView(name: "Wait")
            }
        }
    }
    
    func startLogin(){
        lobbyVM.startLogIn()
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView<LobbyVMUnitTest>()
            .environmentObject(LobbyVMUnitTest(isOk: false, isProcessing: false))
    }
}
