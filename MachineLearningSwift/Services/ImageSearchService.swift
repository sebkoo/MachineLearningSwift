//
//  ImageSearchService.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import Foundation

struct ImageSearchService {
    let apiKey: String = "50789387-4d6a71a30c45bea22ca009a17"

    func searchImages(query: String) async throws -> [ImageResult] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }

        let urlString = "https://pixabay.com/api/?key=\(apiKey)&q=\(encodedQuery)&image_type=photo"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ImageSearchResponse.self, from: data)
        return decoded.hits
    }
}
