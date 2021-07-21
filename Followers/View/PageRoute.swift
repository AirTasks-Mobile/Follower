//
//  PageRoute.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 21/07/2021.
//

import SwiftUI

struct PageRoute<T: RouteViewModelProtocol>: View {
    @EnvironmentObject var routeVM : T
    @EnvironmentObject var lobbyVM : LobbyVM
    var homeVM = HomeVM()
    
    @State var msg : String = ""
    
    var body: some View {
        if routeVM.isHome {
            HomePage<HomeVM>(msg: $msg)
                .environmentObject(homeVM)
        }
        else if routeVM.isState {
            FollowerView(goBack: backHome)
        }
        else if routeVM.isScanQR {
            ScanQRCodeView(msg: $msg, goBack: backHome)
        }
        else if routeVM.isPigeon {
            Pigeon(goBack: backHome)
        }
        else {
            LobbyView<LobbyVM>()
        }
    }
    
    func backHome(){
        routeVM.backHome()
    }
    
    func backLobby(){
        lobbyVM.startLogOut()
    }
}

struct PageRoute_Previews: PreviewProvider {
    static var previews: some View {
        PageRoute<RouteVMUnitTest>()
            .environmentObject(RouteVMUnitTest(isOnline: true, isHome: true, isScanQR: false, isState: false))
    }
}
