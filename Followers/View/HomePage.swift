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
    
    
    private let startColour : Color = Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255)
    private let endColour : Color = Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255)
    private let centerColour : Color = Color(red : 232.0/255, green: 206.0/255, blue: 100.0/255)
    
    
    var body: some View {
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView()
                        .frame(width: geo.size.width, height: geo.size.height * 0.15)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            BadgeButton(name: "CLOSE", action: backToLobby)
                            
                            Button(action: {
                                routeVM.startSol()
                                
                            }, label: {
                                BadgeTextView(text: $homeVM.totalSol,name: "SOL")
                            })

                            Button(action: {
                                routeVM.startOne()
                            }, label: {
                                BadgeTextView(text: $homeVM.totalOne,name: "ONE")
                            })
                                
                            Button(action: {
                                routeVM.startMatic()
                            }, label: {
                                BadgeTextView(text: $homeVM.totalMatic,name: "MATIC")
                            })
                            
                            Button(action: {
                                routeVM.startBsc()
                            }, label: {
                                BadgeTextView(text: $homeVM.totalBsc,name: "BSC")
                            })
                                
                            BadgeButton(name: "ABOUT", action: onAbout)
                                
                        }
                    }
                    .frame(width: geo.size.width, height: 90)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        if homeVM.solAddressList.count > 0 || homeVM.oneAddressList.count > 0 || homeVM.maticAddressList.count > 0 || homeVM.bscAddressList.count > 0 {
                            ActivityIndicator()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255, opacity: 0.9))
                        }
                        
                        ForEach(homeVM.solCoins, id: \.id) { sol in
                            CoinTag(oneCoin: sol, name: "solana_logo")
                                .frame(height: 95)
                        }
                        
                        ForEach(homeVM.oneCoins, id: \.id) { one in
                            CoinTag(oneCoin: one, name: "one_logo")
                                .frame(height: 95)
                        }
                        
                        ForEach(homeVM.maticCoins, id: \.id) { matic in
                            CoinTag(oneCoin: matic, name: "matic_logo")
                                .frame(height: 95)
                        }
                        
                        ForEach(homeVM.bscCoins, id: \.id) { bsc in
                            CoinTag(oneCoin: bsc, name: "binance_logo")
                                .frame(height: 95)
                        }
                        
                    }
                    .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))

                    Spacer()
                    
                }
                .onAppear(perform: loadInfo)
                .onChange(of: homeVM.mainQueue, perform: { _ in
                    if homeVM.mainQueue.count > 0 {
                        let scheme = homeVM.mainQueue[0]
                        if scheme == GTEXT.SOLANA {
                            if homeVM.solAddressList.count == 0 {
                                homeVM.mainQueue.removeFirst()
                            }
                            homeVM.startSol()
                        }
                        else if scheme == GTEXT.HARMONY {
                            if homeVM.oneAddressList.count == 0 {
                                homeVM.mainQueue.removeFirst()
                            }
                            homeVM.startOne()
                        }
                        else if scheme == GTEXT.POLYGON {
                            if homeVM.maticAddressList.count == 0 {
                                homeVM.mainQueue.removeFirst()
                            }
                            homeVM.startMatic()
                        }
                        else if scheme == GTEXT.BINANCE {
                            if homeVM.bscAddressList.count == 0 {
                                homeVM.mainQueue.removeFirst()
                            }
                            homeVM.startBsc()
                        }
                    }
                })
                .onChange(of: homeVM.solAddressList, perform: { _ in
                    //print("Start Solll")
                    if homeVM.mainQueue.count > 0 && homeVM.mainQueue[0] == GTEXT.SOLANA {
                        homeVM.startSol()
                    }
                })
                .onChange(of: homeVM.oneAddressList, perform: { _ in
                    //print("Start Oneeee")
                    if homeVM.mainQueue.count > 0 && homeVM.mainQueue[0] == GTEXT.HARMONY {
                        homeVM.startOne()
                    }
                })
                .onChange(of: homeVM.maticAddressList, perform: { _ in
                    if homeVM.mainQueue.count > 0 && homeVM.mainQueue[0] == GTEXT.POLYGON {
                        homeVM.startMatic()
                    }
                })
                .onChange(of: homeVM.bscAddressList, perform: { _ in
                    if homeVM.mainQueue.count > 0 && homeVM.mainQueue[0] == GTEXT.BINANCE {
                        homeVM.startBsc()
                    }
                })
                .background(LinearGradient(gradient: Gradient(colors: [startColour, centerColour, endColour]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .edgesIgnoringSafeArea(.all)

        } // End geo
        
    }
    func startScanner()
    {
        //routeVM.startScanQR()
    }
    
    func loadInfo(){
        //print("loading.....")
        homeVM.startHome()
    }
    
    func backToLobby(){
        lobbyVM.startLogOut()
    }
    
    func onAbout() -> Void {
        routeVM.startAbout()
    }
    
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage<HomeVMUnitTest>()
            .environmentObject(HomeVMUnitTest(isOnline: true))
    }
}
