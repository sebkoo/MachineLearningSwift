//
//  MachineLearningSwiftTests.swift
//  MachineLearningSwiftTests
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import XCTest
@testable import MachineLearningSwift

@MainActor
final class MachineLearningSwiftTests: XCTestCase {

    func test_imageClassifier_init() {
        XCTAssertNoThrow(try ImageClassifier())
    }

    func test_imageClassification() async throws {
        let classifier = try ImageClassifier()
        // User a sampel UIImage (solid color)
        let size = CGSize(width: 224, height: 224)
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let label = try await classifier.classify(image: testImage)
        XCTAssertFalse(label.isEmpty, "Classification label should not be empty")
    }

    func test_viewModel_classify_updatesLabel() async {
        let viewModel = ImageClassifierViewModel()
        // Provide a test image
        let size = CGSize(width: 224, height: 224)
        UIGraphicsBeginImageContext(size)
        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        viewModel.selectedImage = testImage

        await viewModel.classify()

        XCTAssertFalse(viewModel.classLabel.isEmpty)
        XCTAssertFalse(viewModel.classLabel.contains("Error"))
    }
}
