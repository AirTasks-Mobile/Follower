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
    @Binding var isActive : Bool
    var type : String = "coin"
    var isHeader : Bool = false
    var onGoBack : () -> Void
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if isHeader {
                    ZStack {
                        HeaderView()
                        BackButton(action: onGoBack)
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.10)
                }

                if isActive {
                    MyWebView(url: URL(string: getURL())!)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                }
            }
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
            //.edgesIgnoringSafeArea(.all)

        }
    }
    
    func getURL() -> String {
        if type == GTEXT.SOLANA {
            return "https://coinmarketcap.com/currencies/solana/"
        }
        else if type == GTEXT.HARMONY {
            return "https://coinmarketcap.com/currencies/harmony/"
        }
        else if type == GTEXT.POLYGON {
            return "https://coinmarketcap.com/currencies/polygon/"
        }
        else if type == GTEXT.BINANCE {
            return "https://coinmarketcap.com/currencies/binance-coin/"
        }
        else if type == GTEXT.ETHEREUM {
            return "https://coinmarketcap.com/currencies/ethereum/"
        }
        else if type == GTEXT.STELLAR {
            return "https://coinmarketcap.com/currencies/stellar/"
        }
        
        return "https://coinmarketcap.com/"
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
        StatisticView(isActive: .constant(false), onGoBack: { })
    }
}
