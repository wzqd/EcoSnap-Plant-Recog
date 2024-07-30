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
                    if model.captureImageData != nil{
                        PlantDetailView(selectedTab: 3, captureImageData:$model.captureImageData)
                    }
                    
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
