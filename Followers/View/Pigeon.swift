//
//  Pigeon.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 29/04/2021.
//

import SwiftUI

struct Pigeon: View {
    //var state: OState
    
    var body: some View {
        Text("Pigeon")
            
//        ScrollView{
//            MapView(coordinate: state.locationCoordinate)
//                .ignoresSafeArea(edges: .top)
//                .frame(height: 300)
//
//            CircleImageView(image: state.image)
//                .offset(y: -130)
//                .padding(.bottom, -130)
//
//            VStack(alignment: .leading) {
//                Text(state.name)
//                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(.primary)
//                HStack{
//                    Text(state.park)
//                    Spacer()
//                    Text(state.state)
//                }
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//
//                Divider()
//
//                Text("About \(state.name)")
//                    .font(.title2)
//                Text(state.description)
//            }
//            .padding()
//            Spacer()
//        }
//        .navigationTitle(state.name)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Pigeon_Previews: PreviewProvider {
    static var previews: some View {
        //Pigeon(state: ModelData().states[0])
        Pigeon()
    }
}
