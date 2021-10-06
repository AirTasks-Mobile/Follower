//
//  FollowerView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 20/07/2021.
//

import SwiftUI
import WebKit

struct FollowerView: View {
    @EnvironmentObject var lobbyVM : LobbyVM
    
    @State private var select = 0
    var goBack : () -> Void
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack{
                    HeaderView()
                    BackButton(action: goBack)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.15)
                
                TabView (selection: $select) {
                        StateWebView(url: URL(string: getInfo(own: "yes", all: "na"))!)
                            //.padding(.top, 30)
                            //.frame(height: 550, alignment: .center)
                            .tabItem {
                                    Image(systemName: "flag.circle.fill")
                                    Text("My States")
                                }
                                .tag(0)
                     
                        StateWebView(url: URL(string: getInfo(own: "no", all: "na"))!)
                            .tabItem {
                                Image(systemName: "target")
                                Text("My Footprints")
                            }
                            .tag(1)
                     
                        StateWebView(url: URL(string: getInfo(own: "no", all: "yes"))!)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .tabItem {
                                Image(systemName: "globe")
                                Text("All")
                            }
                            .tag(2)

                }
                
            }
        }
        .background(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255))
        .edgesIgnoringSafeArea(.all)
        //.ignoresSafeArea()
    }
    
    func getInfo(own: String, all: String) -> String {
        var username : String = lobbyVM.userID
        if username == "" {
            username = "unknown_user"
        }
        let page = "http://192.168.43.11:5000/statistic/state"
        
        if all != "yes" {
            if own == "yes" {
                let url = page + "?user=" + username + "&owned=yes"
                return url
            }
            let url = page + "?user=" + username + "&visited=yes"
            return  url
        }
        
        let url = page + "?user=" + username + "&global=yes"
        return url
    }
    
}

struct StateWebView : UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<StateWebView>) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<StateWebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalCacheData)
        webview.load(request)
    }
}

struct FollowerView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerView(goBack: {
            print("back")
        })
        .environmentObject(LobbyVMUnitTest(isOk: true, isProcessing: false))
    }
}
