//
//  CameraView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/7/18.
//

import Foundation
import SwiftUI
import AVFoundation
import CoreImage
import os.log


class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    @Published var isPhotoProcessed = false
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()

    let photoMgr = PhotoManager(smartAlbum: .smartAlbumUserLibrary)
    
    private var photoOutput: AVCapturePhotoOutput?
    
    override init() {
        super.init()
        self.checkPermission()
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    
    /// check permission for the camera for different cases
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.permissionGranted = true
                
            case .notDetermined: // The user has not yet been asked for camera access.
                self.requestPermission()
                
        // Combine the two other cases into the default case
        default:
            self.permissionGranted = false
        }
    }
    
    
    /// request camera permission
    func requestPermission() {
        // Strong reference not a problem here but might become one in the future.
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    
    /// initialize capture session
    func setupCaptureSession() {

        guard permissionGranted else { return }
        
        
        captureSession.beginConfiguration()
        
        
        
        let videoOutput = AVCaptureVideoDataOutput()
        let photoOutput = AVCapturePhotoOutput()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        
        //set video input
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else {return }
        captureSession.addInput(videoDeviceInput)
        
        //set video output
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        guard captureSession.canAddOutput(videoOutput) else {return}
        captureSession.addOutput(videoOutput)
        
        //set photo output
        guard captureSession.canAddOutput(photoOutput)else{return}
        captureSession.addOutput(photoOutput)
        
        self.photoOutput = photoOutput
        
        
        
        videoOutput
            .connection(with: .video)? //set video connection
            .videoRotationAngle = 90 //set frame angle to be right up
        
        
        
        captureSession.commitConfiguration()
    }
    
    
    /// take photo (photo processed in the delegate below)
    func takePhoto() {
        guard let photoOutput = self.photoOutput else { return }

        
        sessionQueue.async {

            var photoSettings = AVCapturePhotoSettings()

            if photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            }
            
            
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .balanced
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)

        }
    }
}



//cpature frame view delegate
extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        // All UI updates should be/ must be performed on the main queue.
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    
}



//photo processing delegate
extension FrameHandler: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print(error)
            return
        }
        
        photoMgr.saveImage(photo) //save photo to photo library
        
        guard let imageData = photo.fileDataRepresentation() else { print("failed to change to imagedata")
            return }
        
        self.isPhotoProcessed = true
        
        
        
    }
}


//view for the capture frame
struct FrameView: View{
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View{
        GeometryReader { geometry in
            if let image = image{
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            else{ //if not successfully shown, show a default black page
                Color.black
                
            }
        }
    }
    
}



//the whole camera page
struct CameraView:View {
    @StateObject var model = FrameHandler()
    
    
    var body: some View {
        GeometryReader { geometry in
            FrameView(image: model.frame)
                .overlay(alignment: .top) {
                    Color.black
                        .opacity(0.75)
                        .frame(height: geometry.size.height * 0.15)
                }
                .overlay(alignment: .bottom) {
                    PhotoButtonsView(model: model)
                        .frame(height: geometry.size.height * 0.25)
                        .background(.black.opacity(0.75))
                }
                .overlay(alignment: .center)  {
                    Color.clear
                        .frame(height: geometry.size.height * (1 - 0.15-0.25))
                }
                .background(.black)
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
}


//bottons in the camera page
struct PhotoButtonsView:View{
    @ObservedObject var model: FrameHandler
    
    
    var body: some View{
        HStack(spacing: 60) {

            
            Spacer()
            

                
                Button {
                    model.takePhoto()
                } label: {
                    Label {
                        Text("Take Photo")
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .sheet(isPresented: $model.isPhotoProcessed, content: {
                    PlantDetailView()
                })
            
                           

            
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}



#Preview {
    CameraView()
}
