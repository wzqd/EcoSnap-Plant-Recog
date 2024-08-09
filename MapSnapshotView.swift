//
//  MapSnapshotView.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/8/9.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


struct MapSnapshotView: View {
    let location: CLLocationCoordinate2D
    var span: CLLocationDegrees = 0.01
    
    @State private var snapshotImage: UIImage?
    
    var body: some View {
        Group {
            if let image = snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(Color(UIColor.secondarySystemBackground))
            }
        }
        .onAppear {
            generateSnapshot(width: 300, height: 300)
        }
    }
    

    func generateSnapshot(width: CGFloat, height: CGFloat) {
      // The region the map should display
      let region = MKCoordinateRegion(
        center: self.location,
        span: MKCoordinateSpan(
          latitudeDelta: self.span,
          longitudeDelta: self.span
        )
      )

      // Map option
      let mapOptions = MKMapSnapshotter.Options()
      mapOptions.region = region
      mapOptions.size = CGSize(width: width, height: height)

      // Create the snapshotter and run it
      let snapshotter = MKMapSnapshotter(options: mapOptions)
      snapshotter.start { (snapshot, error) in
        if let error = error {
          print(error)
          return
        }
        if let snapshot = snapshot {
          self.snapshotImage = snapshot.image
        }
      }
    }
}
