//
//  Features.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 28/05/2021.
//

import Foundation
import Combine
import SwiftUI

struct Icon: Hashable, Codable, Identifiable {
    var id: Int
    var iconName: String
    var imageName: String
    var iconImage: Image {
        Image(imageName)
    }
}

final class Features : ObservableObject {
    @Published var features: [Icon] = load("features.json")
   
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
