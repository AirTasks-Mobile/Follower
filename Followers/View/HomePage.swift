//
//  HomePage.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 19/07/2021.
//

import SwiftUI

struct HomePage<T: HomeViewModelProtocol>: View {
    private var homeVM = HomeVM()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HeaderView()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.20)
                            //.background(Color.green)
                    
                    ScrollView(.vertical) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                BadgeButton(name: "Info", action: backToInfo)
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "Pigeon")
                                    })
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "Sparrows")
                                    })
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "My States")
                                    })
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "Go")
                                    })
                                
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "Goo")
                                    })
                                
                                NavigationLink(
                                    destination: Pigeon(),
                                    label: {
                                        BadgeTextView(name: "Gooo")
                                    })
                            }
                        }
                        .frame(width: geometry.size.width, height: 90)
                        .padding(.top, 30)
                       
                        
                        StatisticView()
                    }
                }
                .background(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255))
                .ignoresSafeArea()
                .onAppear(perform: loadInfo)
            }
        }
        
    }
    
    func loadInfo(){
        homeVM.fetchInfo()
    }
    
    func backToInfo(){
        
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage<HomeVMUnitTest>()
            .environmentObject(HomeVMUnitTest(isOnline: true, pigeon: ["Pigeon" : "Number One"], sparrows: ["Sparrow" : "Number Two"], vState: ["State" : "State One"], oState: ["State" : "State Two"]))
    }
}
