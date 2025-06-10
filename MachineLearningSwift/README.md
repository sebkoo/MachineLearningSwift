# MyCoreMLApp

A SwiftUI app that classifies images using Apple's MobileNetV2 Core ML model.

- SwiftUI with async/await
- Core ML integration
- Image Picker support
- TDD with XCTest
- Supports iOS 15+

## Usage

1. Select an image.
2. Tap "Classify".
3. View classification result.

## Setup

- Download MobileNetV2.mlmodel from [Apple Developer ML Models](https://developer.apple.com/machine-learning/models/)
- Add the model to the Xcode project.

## Testing

Run tests with:

```bash
xcodebuild test -scheme MyCoreMLApp -destination 'platform=iOS Simulator,name=iPhone 14'
