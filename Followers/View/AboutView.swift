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
            ScrollView {
                ZStack {
                    HeaderView()
                    BackButton(action: {
                        routeVM.backHome()
                    })
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.10)
                
                Text("Hello, There!")
                        .font(Font.custom("Avenir-medium", size: 17))
                        .foregroundColor(Color.blue)
                        .padding(EdgeInsets(top: 15, leading: 27, bottom: 0, trailing: 27))
                
                Text("I am you diary, I will assist you to keep track your coin's accounts")
                        .font(Font.custom("Avenir-medium", size: 15))
                        .foregroundColor(Color.blue)
                        .padding(EdgeInsets(top: 3, leading: 27, bottom: 0, trailing: 27))
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView<RouteVMUnitTest>()
            .environmentObject(RouteVMUnitTest(isOnline: true))
    }
}
