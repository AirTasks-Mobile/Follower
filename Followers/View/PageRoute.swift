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
    
//    @State var startColour : Color = Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255)
//    @State var endColour : Color = Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255)
//    @State var centerColour : Color = Color(red : 232.0/255, green: 206.0/255, blue: 100.0/255)
//
    var body: some View {
        if routeVM.isHome {
            HomePage<HomeVM>()
                .environmentObject(homeVM)
        }
        else if routeVM.isSol {
            SOLTab<HomeVM>(goBack: backHome)
                .environmentObject(homeVM)
        }
        else if routeVM.isOne {
            ONETab<HomeVM>(goBack: backHome)
                .environmentObject(homeVM)
        }
        else if routeVM.isMatic {
            MATICTab<HomeVM>(goBack: backHome)
                .environmentObject(homeVM)
        }
        else if routeVM.isAbout {
            AboutView<RouteVM>()
                .environmentObject(routeVM)
        }
        else if routeVM.isBsc{
            BSCTab<HomeVM>(goBack: backHome)
                .environmentObject(homeVM)
        }
        else {
            
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
            .environmentObject(RouteVMUnitTest(isOnline: true))
    }
}
