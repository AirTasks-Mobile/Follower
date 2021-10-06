//
//  HomePage.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct HomePage<T: HomeViewModelProtocol>: View {
    @EnvironmentObject var homeVM : T
    @EnvironmentObject var lobbyVM : LobbyVM
    @EnvironmentObject var routeVM : RouteVM
    
    @Binding var msg : String
    @Binding var backgroundColor : Color
    
    var body: some View {
        //NavigationView {
            GeometryReader { geometry in
                VStack {
                    HeaderView()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                    
                    ScrollView(.vertical) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                BadgeButton(name: "Close", action: backToInfo)
                                Button(action: {
                                    routeVM.startState()
                                }, label: {
                                    BadgeTextView(name: "State")
                                })

                                Button(action: {
                                    routeVM.startPigeon()
                                }, label: {
                                    BadgeTextView(name: "Pigeon")
                                })
                                
                                Button(action: {
                                    routeVM.startPigeon()
                                }, label: {
                                    BadgeTextView(name: "Saprrows")
                                })
                                
                                Button(action: {
                                    routeVM.startPigeon()
                                }, label: {
                                    BadgeTextView(name: "Go")
                                })
                                
                                Button(action: {
                                    routeVM.startPigeon()
                                }, label: {
                                    BadgeTextView(name: "Profile")
                                })
                                
                            }
                            //.navigationViewStyle(StackNavigationViewStyle())
                        }
                        .frame(width: geometry.size.width, height: 90)
                       
                        DecodeMsgView(msg: $msg, clearMsg: homeVM.clearMsg, action: decodeMsg, actionScan: startScanner)
                            .frame(width: geometry.size.width, height: 120)
                            .padding(.top, 30)


                        
                        StatisticView()
                            .padding(.top, 30)
                        
                    }
                    
                }
                .onAppear(perform: loadInfo)
                .background(backgroundColor)
                .edgesIgnoringSafeArea(.all)
                
            //} // end navigationview
        }
        
    }
    func startScanner()
    {
        routeVM.startScanQR()
    }
    
    func loadInfo(){
        print("loading.....")
        homeVM.fetchInfo()
    }
    
    func backToInfo(){
        lobbyVM.startLogOut()
    }
    
    func decodeMsg()
    {
        homeVM.getClearMsg(info: msg)
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage<HomeVMUnitTest>(msg: .constant("msg"), backgroundColor : .constant(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255)))
            .environmentObject(HomeVMUnitTest(isOnline: true, pigeon: ["Pigeon" : "Number One"], sparrows: ["Sparrow" : "Number Two"], vState: ["State" : "State One"], oState: ["State" : "State Two"], clearMsg: "String"))
    }
}
