//
//  LobbyView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct LobbyView<T: LobbyViewModelProtocol>: View {
    @EnvironmentObject private var lobbyVM : T
    @State var textTemp : String = ""
    var body: some View {
        GeometryReader { geo in
            VStack{
            if !lobbyVM.isProcessing {
                BadgeButton(name: getText(), action: startLogin)
            }
            else {
                BadgeTextView(text: $textTemp, name: "Wait", primary: false)
            }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255))
        }
        .edgesIgnoringSafeArea(.all)
        //.ignoresSafeArea()
    }
    
    func startLogin(){
        lobbyVM.startLogIn()
    }
    
    func getText() -> String {
        let firstTime : String = UserDefaults.standard.string(forKey: GTEXT.FIRST_TIME) ?? ""
        
        if firstTime == "" {
            //UserDefaults.standard.set("NO", forKey: GTEXT.FIRST_TIME)
            return "Tap above icon to start!"
        }
        
    
        return "MOON"
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView<LobbyVMUnitTest>()
            .environmentObject(LobbyVMUnitTest(isOk: false, isProcessing: false))
    }
}
