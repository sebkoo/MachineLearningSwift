//
//  ImageResult.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import Foundation

struct ImageResult: Decodable, Identifiable {
    let id: Int
    let previewURL: String
    let largeImageURL: String
}

struct ImageSearchResponse: Decodable {
    let hits: [ImageResult]
}
