//
//  ContentView.swift
//  MachineLearningSwift
//
//  Created by Bonmyeong Koo - Vendor on 6/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageClassifierViewModel()
    @State private var showImagePicker = false
    @State private var showErrorAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                selectedImageView
                resultLabel
                buttonBar

                if viewModel.isLoading {
                    ProgressView("Classifying...")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Image Classifier")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage ?? "Unknown error"),
                      dismissButton: .default(Text("OK")))
            }
            .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                showErrorAlert = viewModel.errorMessage != nil
            }
        }
    }

    var selectedImageView: some View {
        Group {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .cornerRadius(10)
                    .overlay {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
            }
        }
    }

    var resultLabel: some View {
        Text(viewModel.classLabel)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
    }

    var buttonBar: some View {
        HStack {
            Button("Select Image") {
                showImagePicker = true
            }
            .buttonStyle(.borderedProminent)

            Button("Classify") {
                Task {
                    await viewModel.classify()
                }
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.selectedImage == nil || viewModel.isLoading)

            NavigationLink("Search Online") {
                SearchResultsView(query: viewModel.classLabel)
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.classLabel == "Select an image" || viewModel.isLoading)
        }
    }
}

#Preview {
    ContentView()
}
