////
////  ScanPhotoView.swift
////  PracticeProject
////
////  Created by Aditya Majumdar on 24/08/24.
////
//
//import SwiftUI
//import AVFoundation
//import CoreML
//import Vision
//import PhotosUI
//
//// Protocol to communicate between the UIViewController and SwiftUI
//protocol ScanPhotoViewControllerDelegate: AnyObject {
//    func didUpdateClassification(_ classification: String)
//}
//
//struct ScanPhotoView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var vm = ScannerViewModel()
//    @State private var classificationLabel: String = "Scanning..."
//    @State private var showScannedItemView = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if !showScannedItemView { // Only show camera view if ScannedItemView is not presented
//                    ScanPhotoViewControllerWrapper(vm: vm, classificationLabel: $classificationLabel, showScannedItemView: $showScannedItemView)
//                        .id(UUID()) // To force refresh
//                        .background(Color.gray.opacity(0.3))
//                        .ignoresSafeArea(edges: .top)
//                } else {
//                    // Display a placeholder or empty view when the camera is "frozen"
//                    Color.gray.opacity(0.3)
//                        .ignoresSafeArea(edges: .top)
//                }
//            }
//            .onChange(of: vm.isScannerActive, initial: false) {
//                if !vm.isScannerActive {
//                    dismiss()
//                }
//            }
//            .sheet(isPresented: $showScannedItemView) {
//                ScannedItemView(vm: vm)
//            }
//        }
//    }
//}
//
//struct ScanPhotoViewControllerWrapper: UIViewControllerRepresentable {
//    @ObservedObject var vm: ScannerViewModel
//    @Binding var classificationLabel: String
//    @Binding var showScannedItemView: Bool
//    
//    func makeUIViewController(context: Context) -> ScanPhotoViewController {
//        let viewController = ScanPhotoViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: ScanPhotoViewController, context: Context) {
//        uiViewController.updateClassificationLabel(classificationLabel)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, ScanPhotoViewControllerDelegate {
//        var parent: ScanPhotoViewControllerWrapper
//
//        init(_ parent: ScanPhotoViewControllerWrapper) {
//            self.parent = parent
//        }
//
//        func didUpdateClassification(_ classification: String) {
//            parent.classificationLabel = classification
//            parent.fetchFoodData(foodName: classification)
//        }
//    }
//
//    func fetchFoodData(foodName: String) {
//        let apiKey = "da5a32319b55edcbae5aab9bd2cdb5ce"
//        let appId = "f784c79c"
//        let urlString = "https://trackapi.nutritionix.com/v2/search/instant?query=\(foodName)"
//
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.addValue(appId, forHTTPHeaderField: "x-app-id")
//        request.addValue(apiKey, forHTTPHeaderField: "x-app-key")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.showErrorAlert(message: "Failed to fetch data: \(error.localizedDescription)")
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.showErrorAlert(message: "No data received from the server.")
//                }
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let apiResponse = try decoder.decode(NutritionixResponse.self, from: data)
//
//                if let foodItem = apiResponse.common.first {
//                    DispatchQueue.main.async {
//                        self.vm.itemDetails = [foodItem] // Update the ViewModel with the fetched food item
//                        self.showScannedItemView = true
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.showErrorAlert(message: "No food items found.")
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.showErrorAlert(message: "Failed to decode API response: \(error.localizedDescription)")
//                }
//            }
//        }.resume()
//    }
//
//    private func showErrorAlert(message: String) {
//        // Implement a method to show an error alert in your SwiftUI view
//    }
//
//}
//
//struct NutritionixResponse: Decodable {
//    let common: [FoodItem]
//}
//
//
//
//class ScanPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    weak var delegate: ScanPhotoViewControllerDelegate?
//
//    private var captureSession: AVCaptureSession?
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//    private let photoOutput = AVCapturePhotoOutput()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        startCameraSession()
//        setupUI()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        stopCameraSession()
//    }
//
//    private func startCameraSession() {
//        let session = AVCaptureSession()
//        session.sessionPreset = .photo
//
//        guard let camera = AVCaptureDevice.default(for: .video),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//
//        session.addInput(input)
//        session.addOutput(photoOutput)
//
//        captureSession = session
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer?.videoGravity = .resizeAspectFill
//        previewLayer?.frame = view.layer.bounds
//        if let previewLayer = previewLayer {
//            view.layer.addSublayer(previewLayer)
//        }
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            session.startRunning()
//        }
//    }
//
//    private func stopCameraSession() {
//        captureSession?.stopRunning()
//    }
//
//    private func setupUI() {
//        let captureButton = UIButton(type: .system)
//        captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
//        captureButton.tintColor = .white
//        captureButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        captureButton.layer.cornerRadius = 40
//        captureButton.translatesAutoresizingMaskIntoConstraints = false
//        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
//
//        let chooseButton = UIButton(type: .system)
//        chooseButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
//        chooseButton.tintColor = .white
//        chooseButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        chooseButton.layer.cornerRadius = 25
//        chooseButton.translatesAutoresizingMaskIntoConstraints = false
//        chooseButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
//
//        view.addSubview(captureButton)
//        view.addSubview(chooseButton)
//
//        NSLayoutConstraint.activate([
//            captureButton.widthAnchor.constraint(equalToConstant: 100),
//            captureButton.heightAnchor.constraint(equalToConstant: 100),
//            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
//
//            chooseButton.widthAnchor.constraint(equalToConstant: 50),
//            chooseButton.heightAnchor.constraint(equalToConstant: 50),
//            chooseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
//        ])
//    }
//
//    @objc private func capturePhoto() {
//        let settings = AVCapturePhotoSettings()
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//
//    @objc private func choosePhoto() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
//    }
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(),
//              let ciImage = CIImage(data: imageData),
//              let pixelBuffer = ciImage.toCVPixelBuffer() else { return }
//
//        stopCameraSession()
//        classifyImage(pixelBuffer: pixelBuffer)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        if let image = info[.originalImage] as? UIImage,
//           let ciImage = CIImage(image: image),
//           let pixelBuffer = ciImage.toCVPixelBuffer() {
//            stopCameraSession()
//            classifyImage(pixelBuffer: pixelBuffer)
//        }
//    }
//
//    private func classifyImage(pixelBuffer: CVPixelBuffer) {
//        guard let model = try? VNCoreMLModel(for: Food_Classifier().model) else { return }
//
//        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//            guard let results = request.results as? [VNClassificationObservation],
//                  let topResult = results.first else { return }
//
//            let classificationResult = topResult.identifier // Extract just the food name
//
//            DispatchQueue.main.async {
//                self?.delegate?.didUpdateClassification(classificationResult)
//            }
//        }
//
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        try? handler.perform([request])
//    }
//
//    func updateClassificationLabel(_ classification: String) {
//        // Handle UI update if needed
//    }
//}
//
//
//// Extension to convert CIImage to CVPixelBuffer
//extension CIImage {
//    func toCVPixelBuffer() -> CVPixelBuffer? {
//        let attributes: [CFString: Any] = [
//            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
//            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
//        ]
//        var pixelBuffer: CVPixelBuffer?
//        let width = Int(self.extent.width)
//        let height = Int(self.extent.height)
//
//        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attributes as CFDictionary, &pixelBuffer)
//
//        guard let buffer = pixelBuffer else { return nil }
//
//        let context = CIContext()
//        context.render(self, to: buffer)
//        return buffer
//    }
//}




//
//  ScanPhotoView.swift
//  PracticeProject
//
//  Created by Aditya Majumdar on 24/08/24.
//

import SwiftUI
import AVFoundation
import CoreML
import Vision
import PhotosUI

// Protocol to communicate between the UIViewController and SwiftUI
protocol ScanPhotoViewControllerDelegate: AnyObject {
    func didUpdateClassification(_ classification: String)
}

struct ScanPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ScannerViewModel()
    @State private var classificationLabel: String = "Scanning..."
    @State private var showScannedItemView = false

    var body: some View {
        NavigationStack {
            VStack {
                if !showScannedItemView { // Only show camera view if ScannedItemView is not presented
                    ScanPhotoViewControllerWrapper(vm: vm, classificationLabel: $classificationLabel, showScannedItemView: $showScannedItemView)
                        .id(UUID()) // To force refresh
                        .background(Color.gray.opacity(0.3))
                        .ignoresSafeArea(edges: .top)
                } else {
                    // Display a placeholder or empty view when the camera is "frozen"
                    Color.gray.opacity(0.3)
                        .ignoresSafeArea(edges: .top)
                }
            }
            .onChange(of: vm.isScannerActive, initial: false) {
                if !vm.isScannerActive {
                    dismiss()
                }
            }
            .sheet(isPresented: $showScannedItemView) {
                ScannedItemView(vm: vm)
            }
        }
    }
}

struct ScanPhotoViewControllerWrapper: UIViewControllerRepresentable {
    @ObservedObject var vm: ScannerViewModel
    @Binding var classificationLabel: String
    @Binding var showScannedItemView: Bool

    func makeUIViewController(context: Context) -> ScanPhotoViewController {
        let viewController = ScanPhotoViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: ScanPhotoViewController, context: Context) {
        uiViewController.updateClassificationLabel(classificationLabel)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ScanPhotoViewControllerDelegate {
        var parent: ScanPhotoViewControllerWrapper

        init(_ parent: ScanPhotoViewControllerWrapper) {
            self.parent = parent
        }

        func didUpdateClassification(_ classification: String) {
            parent.classificationLabel = classification
            parent.fetchFoodData(foodName: classification)
        }
    }

    func fetchFoodData(foodName: String) {
        let apiKey = "vJXWHeYc8EaCFQMdVrJSRl7oXmTdgnHB9V7eTgan"
        let searchUrlString = "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(foodName)&api_key=\(apiKey)"

        guard let searchUrl = URL(string: searchUrlString) else {
            showErrorAlert(message: "Invalid URL.")
            return
        }

        var searchRequest = URLRequest(url: searchUrl)
        searchRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: searchRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Failed to fetch food data: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Failed to fetch food data: No data.")
                }
                return
            }

            do {
                let apiResponse = try JSONDecoder().decode(USDAFoodSearchResponse.self, from: data)

                if let exactMatch = apiResponse.foods.first(where: {
                    if let description = $0.description {
                        return description.lowercased() == foodName.lowercased()
                    }
                    return false
                }) {
                    DispatchQueue.main.async {
                        self.vm.itemDetails = [exactMatch.toFoodItem()]
                        self.showScannedItemView = true
                    }
                } else if let closestMatch = apiResponse.foods.first {
                    DispatchQueue.main.async {
                        self.vm.itemDetails = [closestMatch.toFoodItem()]
                        self.showScannedItemView = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "No food items found.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "Failed to decode food data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }


    private func showErrorAlert(message: String) {
        // Implement a method to show an error alert in your SwiftUI view
    }

}

struct NutritionixResponse: Decodable {
    let foods: [Food]

    struct Food: Decodable {
        let foodName: String
        let calories: Double?  // Update this based on the actual API field name
        let photo: Photo
        
        struct Photo: Decodable {
            let thumb: String
        }
    }
}





class ScanPhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: ScanPhotoViewControllerDelegate?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let photoOutput = AVCapturePhotoOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        startCameraSession()
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraSession()
    }

    private func startCameraSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }

        session.addInput(input)
        session.addOutput(photoOutput)

        captureSession = session

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            session.startRunning()
        }
    }

    private func stopCameraSession() {
        captureSession?.stopRunning()
    }

    private func setupUI() {
        let captureButton = UIButton(type: .system)
        captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        captureButton.tintColor = .white
        captureButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        captureButton.layer.cornerRadius = 40
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)

        let chooseButton = UIButton(type: .system)
        chooseButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        chooseButton.tintColor = .white
        chooseButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        chooseButton.layer.cornerRadius = 25
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)

        view.addSubview(captureButton)
        view.addSubview(chooseButton)

        NSLayoutConstraint.activate([
            captureButton.widthAnchor.constraint(equalToConstant: 100),
            captureButton.heightAnchor.constraint(equalToConstant: 100),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),

            chooseButton.widthAnchor.constraint(equalToConstant: 50),
            chooseButton.heightAnchor.constraint(equalToConstant: 50),
            chooseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    @objc private func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let ciImage = CIImage(data: imageData),
              let pixelBuffer = ciImage.toCVPixelBuffer() else { return }

        stopCameraSession()
        classifyImage(pixelBuffer: pixelBuffer)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage,
           let ciImage = CIImage(image: image),
           let pixelBuffer = ciImage.toCVPixelBuffer() {
            stopCameraSession()
            classifyImage(pixelBuffer: pixelBuffer)
        }
    }

    private func classifyImage(pixelBuffer: CVPixelBuffer) {
        guard let model = try? VNCoreMLModel(for: Food_Classifier().model) else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }

            let classificationResult = topResult.identifier // Extract just the food name

            DispatchQueue.main.async {
                self?.delegate?.didUpdateClassification(classificationResult)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }

    func updateClassificationLabel(_ classification: String) {
        // Handle UI update if needed
    }
}


// Extension to convert CIImage to CVPixelBuffer
extension CIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ]
        var pixelBuffer: CVPixelBuffer?
        let width = Int(self.extent.width)
        let height = Int(self.extent.height)

        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attributes as CFDictionary, &pixelBuffer)

        guard let buffer = pixelBuffer else { return nil }

        let context = CIContext()
        context.render(self, to: buffer)
        return buffer
    }
}
