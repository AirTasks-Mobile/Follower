//
//  FollowerView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 20/07/2021.
//

import SwiftUI
import WebKit

struct FollowerView: View {
    var username : String = "user001"
    var page = "http://192.168.43.11:5000/statistic/state"
    
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
                        StateWebView(url: URL(string: getInfo(own: "yes", state: "na"))!)
                            .padding(.top, 30)
                            .frame(height: 550, alignment: .center)
                            .tabItem {
                                    Image(systemName: "house.fill")
                                    Text("My States")
                                }
                                .tag(0)
                     
                        StateWebView(url: URL(string: getInfo(own: "no", state: "na"))!)
                        .padding(.top, 30)
                            .frame(height: 550, alignment: .center)
                            .tabItem {
                                Image(systemName: "bookmark.circle.fill")
                                Text("My Footprints")
                            }
                            .tag(1)
                     
//                        Text("Video Tab")
//                            .font(.system(size: 30, weight: .bold, design: .rounded))
//                            .tabItem {
//                                Image(systemName: "video.circle.fill")
//                                Text("Video")
//                            }
//                            .tag(2)
//
//                        Text("Profile Tab")
//                            .font(.system(size: 30, weight: .bold, design: .rounded))
//                            .tabItem {
//                                Image(systemName: "person.crop.circle")
//                                Text("Profile")
//                            }
//                            .tag(3)
                }
                
            }
        }
        .background(Color(red : 219.0/255, green: 227.0/255, blue: 145.0/255))
        .edgesIgnoringSafeArea(.all)
        //.ignoresSafeArea()
    }
    
    func getInfo(own: String, state: String) -> String {
        
        if own == "yes" {
            let url = page + "?state=" + "BEL" + "&user=" + username
            return url
        }
        //let url = page + "state=" + "BEL" + "&user=" + username
        let url = page + "?user=" + username
        
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
    }
}
