//
//  ImageClassifier.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import UIKit
@preconcurrency import Vision
import Foundation

final class ImageClassifier {
    private let model: VNCoreMLModel

    init() throws {
        let modelML = try MobileNetV2(configuration: MLModelConfiguration()).model
        self.model = try VNCoreMLModel(for: modelML)
    }

    func classify(image: UIImage) async throws -> String {
        guard let coreImage = CIImage(image: image) else {
            throw NSError(domain: "ImageClassifier", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create CIImage"])
        }

        let request = VNCoreMLRequest(model: model)

        return try await withCheckedThrowingContinuation { continuation in
            let handler = VNImageRequestHandler(ciImage: coreImage)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                    if let results = request.results as? [VNClassificationObservation],
                       let topResult = results.first {
                        continuation.resume(returning: topResult.identifier)
                    } else {
                        continuation.resume(throwing: NSError(domain: "ImageClassifier", code: -2, userInfo: [NSLocalizedDescriptionKey: "No classification found"]))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
