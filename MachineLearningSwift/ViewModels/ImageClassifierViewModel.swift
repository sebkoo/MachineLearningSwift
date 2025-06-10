//
//  ImageClassifierViewModel.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import Foundation
import UIKit

@MainActor
final class ImageClassifierViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var classLabel: String = "Select an image"
    @Published var isLoading: Bool = false

    private let classifier: ImageClassifier

    init() {
        do {
            classifier = try ImageClassifier()
        } catch {
            fatalError("Failed to load model: \(error)")
        }
    }

    func classify() async {
        guard let image = selectedImage else { return }
        isLoading = true
        do {
            let label = try await classifier.classify(image: image)
            classLabel = label
        } catch {
            classLabel = "Error: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
