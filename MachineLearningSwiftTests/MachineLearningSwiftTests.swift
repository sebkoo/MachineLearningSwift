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

    func test_isLoadingState_duringClassification() async {
        let viewModel = ImageClassifierViewModel()

        let size = CGSize(width: 224, height: 224)
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        viewModel.selectedImage = testImage

        let expectation = XCTestExpectation(description: "Classification should complete")

        Task {
            await viewModel.classify()
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertFalse(viewModel.classLabel.isEmpty)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5)
    }

    func test_errorState_whenNoImageProvided() async {
        let viewModel = ImageClassifierViewModel()

        await viewModel.classify()

        XCTAssertEqual(viewModel.classLabel, "Select an image")
    }

    func test_PixabayAPI_parseResponse() throws {
        let json = """
            {
              "hits": [
                {
                  "id": 123,
                  "previewURL": "https://example.com/preview.jpg",
                  "largeImageURL": "https://example.com/large.jpg"
                }
              ]
            }
            """
        let data = json.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(ImageSearchResponse.self, from: data)
        XCTAssertEqual(decoded.hits.count, 1)
        XCTAssertEqual(decoded.hits[0].id, 123)
    }
}
