//
//  AboutView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 04/01/2022.
//

import SwiftUI

struct AboutView<T: RouteViewModelProtocol>: View {
    @EnvironmentObject var routeVM : T
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                ZStack {
                    HeaderView()
                    BackButton(action: {
                        routeVM.backHome()
                    })
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.10)
                
                ScrollView(showsIndicators: false) {
                    Text("Hello !!!")
                            .font(Font.custom("Avenir-back", size: 19))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 0, trailing: 27))
                    
                    Text("I'm glad to see you here.")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 0, trailing: 27))
                    
                    Text("This App is to help you keep track your staking rewards and transactions's history  on Solana and Harmony One networks. Ethereum, Polygon, Binance Smart Chain only can see balances for now")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 0, trailing: 27))
                    
                    Text("To add a new coin/token. Tap on the icon with its name at Home Screen, tap 'Click To Add New Coin !'. Then you can enter/paste/scan an Address/Account. You would give it a nick name as well ")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 0, trailing: 27))
                    
                    Text("To see transactions and staking reward. Navigate to its page by tapping on the icon associated with its name at Home Screen. Tap on the account that you want to check")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 0, trailing: 27))
                    
                    Text("To see coin's price. Navigate to its page by tapping on the icon associated with its name at Home Screen. Swipe right ( to access pages on the left), you now can see coinmarketcap. One more right swipe then you find the place where you can delete your added coins")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 0, trailing: 27))
                    
                    CircleButton(name: "yellow_flower_03")
                            .frame(width: 90, height: 90, alignment: .center)
                    Text("More to come.")
                            .font(Font.custom("Avenir-medium", size: 15))
                            .foregroundColor(Color.blue)
                            .padding(EdgeInsets(top: 3, leading: 25, bottom: 15, trailing: 27))
                    
                    
                }
            } // end scroll
            //.padding(EdgeInsets(top: 0, leading: 27, bottom: 15, trailing: 27))
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView<RouteVMUnitTest>()
            .environmentObject(RouteVMUnitTest(isOnline: true))
    }
}
