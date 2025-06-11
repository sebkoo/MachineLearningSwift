//
//  SearchResultsView.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import SwiftUI

struct SearchResultsView: View {
    @StateObject private var viewModel = SearchResultViewModel()
    let query: String

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Searching...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()),
                                        GridItem(.flexible())], spacing: 10) {
                        ForEach(viewModel.images) { image in
                            AsyncImage(url: URL(string: image.previewURL)) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray.opacity(0.2)
                                        .frame(height: 100)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 100)
                                        .clipped()
                                case .failure:
                                    Color.red.frame(height: 100)
                                @unknown default:
                                    Color.black.frame(height: 100)
                                }
                            }
                        }
                    }.padding()
                }
            }
        }
        .navigationTitle("Results for “\(query)“")
        .task {
            await viewModel.fetchImages(for: query)
        }
    }
}

#Preview {
    let viewModel = MockSearchResultViewModel()

    SearchResultsView(query: "Cat")
        .environmentObject(viewModel)
        .task {
            await viewModel.fetchImages(for: "Cat")
        }
}
