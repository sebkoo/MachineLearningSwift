//
//  SearchResultViewModel.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import Foundation

@MainActor
class SearchResultViewModel: ObservableObject {
    @Published var images: [ImageResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let service = ImageSearchService()

    func fetchImages(for query: String) async {
        isLoading = true
        errorMessage = nil
        do {
            images = try await service.searchImages(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

@MainActor
final class MockSearchResultViewModel: SearchResultViewModel {
    override func fetchImages(for query: String) async {
        self.images = [
            ImageResult(id: 1, previewURL: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_150.jpg", largeImageURL: ""),
            ImageResult(id: 2, previewURL: "https://cdn.pixabay.com/photo/2016/11/29/04/17/adorable-1866532_150.jpg", largeImageURL: "")
        ]
    }
}
