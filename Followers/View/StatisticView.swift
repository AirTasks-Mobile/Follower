//
//  StatisticView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/05/2021.
//

import SwiftUI
import WebKit

struct StatisticView: View {
    @EnvironmentObject var lobbyVM : LobbyVM
    
    var body: some View {
        MyWebView(url: URL(string: getURL())!)
            .frame(height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    func getURL() -> String {
        var userID = lobbyVM.userID
        if userID == "" {
            userID = "unknown_user"
        }
        
        let url : String = "http://192.168.1.103:5000/statistic/lair?user=" + userID
        
        return url
    }
}

struct MyWebView : UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<MyWebView>) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<MyWebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalCacheData)
        webview.load(request)
    }
    
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
