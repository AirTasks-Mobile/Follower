//
//  StatisticView.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/05/2021.
//

import SwiftUI
import WebKit

struct StatisticView: View {
    var body: some View {
        MyWebView(url: URL(string: "http://192.168.43.11:5000/statistic")!)
            .frame(height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
