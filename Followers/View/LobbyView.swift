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
        GeometryReader { geo in
            VStack{
            if !lobbyVM.isProcessing{
                BadgeButton(name: "GO", action: startLogin)
            }
            else {
                BadgeTextView(name: "Wait", primary: false)
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
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView<LobbyVMUnitTest>()
            .environmentObject(LobbyVMUnitTest(isOk: false, isProcessing: false))
    }
}


//                    HStack {
//                        Image(systemName: "calendar")
//                        Text("Select time slot")
//                            .font(.title2)
//                        Picker(selection: $selectedTime, label: Text(""), content: {
//                            ForEach(0 ..< timeSlots.count){ count in
//                                Text(self.timeSlots[count])
//                                    .tag(count)
//                            }
//                        })
//
//                    }
//                    .padding(.top, 20)
