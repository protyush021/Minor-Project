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

struct ScanPhotoView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @State private var classificationLabel: String = "Scanning..."

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
        var parent: ScanPhotoView

        init(_ parent: ScanPhotoView) {
            self.parent = parent
        }

        func didUpdateClassification(_ classification: String) {
            parent.classificationLabel = classification
        }
    }
}

// Delegate protocol to communicate between the UIViewController and SwiftUI
protocol ScanPhotoViewControllerDelegate: AnyObject {
    func didUpdateClassification(_ classification: String)
}

// UIViewController that handles camera, photo library, and CoreML classification
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

        // Start running the session
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            session.startRunning()
        }
    }

    private func stopCameraSession() {
        captureSession?.stopRunning()
    }

    private func setupUI() {
            // Create capture button with icon
            let captureButton = UIButton(type: .system)
            captureButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
            captureButton.tintColor = .white
            captureButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            captureButton.layer.cornerRadius = 40
            captureButton.translatesAutoresizingMaskIntoConstraints = false
            captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)

            // Create choose button with icon
            let chooseButton = UIButton(type: .system)
            chooseButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
            chooseButton.tintColor = .white
            chooseButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            chooseButton.layer.cornerRadius = 25
            chooseButton.translatesAutoresizingMaskIntoConstraints = false
            chooseButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)

            // Add buttons to view
            view.addSubview(captureButton)
            view.addSubview(chooseButton)

            // Set up constraints for buttons
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

    // Handle captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let ciImage = CIImage(data: imageData),
              let pixelBuffer = ciImage.toCVPixelBuffer() else { return }

        // Stop the camera session
        stopCameraSession()

        classifyImage(pixelBuffer: pixelBuffer)
    }

    // Handle selected photo from photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage,
           let ciImage = CIImage(image: image),
           let pixelBuffer = ciImage.toCVPixelBuffer() {
            // Stop the camera session
            stopCameraSession()

            classifyImage(pixelBuffer: pixelBuffer)
        }
    }

    private func classifyImage(pixelBuffer: CVPixelBuffer) {
        guard let model = try? VNCoreMLModel(for: Food_Classifier().model) else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }

            let classificationResult = "\(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
            
            DispatchQueue.main.async {
                // Show alert with the classification result
                self?.showClassificationAlert(result: classificationResult)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }

    private func showClassificationAlert(result: String) {
        let alertController = UIAlertController(title: "Classification Result", message: result, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optionally dismiss the view controller here
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
