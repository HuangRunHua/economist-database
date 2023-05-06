//
//  ImageDetailView.swift
//  Daily News
//
//  Created by Huang Runhua on 5/6/23.
//

import SwiftUI
import NukeUI

struct ImageDetailView: View {
    
    var imagePath: String?
    
    var imageURL: URL? {
        if let imagePath {
            return URL(string: imagePath)
        }
        return nil
    }
    
    @GestureState private var magnifyBy = 1.0
    
    @State private var originalScaleRate: CGFloat = 1.0
    @State private var scaleRate: CGFloat = 1.0
    
    @State private var zoomScale: CGFloat = 1
    @State private var previousZoomScale: CGFloat = 1
    private let minZoomScale: CGFloat = 1
    private let maxZoomScale: CGFloat = 3

//    var magnification: some Gesture {
//        MagnificationGesture()
//            .onChanged { newValue in
//                self.scaleRate = newValue
//            }
//            .onEnded { _ in
//                originalScaleRate = (originalScaleRate * scaleRate) <= 1 ? 1: originalScaleRate * scaleRate
//                scaleRate = 1.0
//            }
//    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                if let imageURL = self.imageURL {
                    LazyImage(url: imageURL, content: { phase in
                        switch phase.result {
                        case .success:
                            phase.image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .onTapGesture(count: 2, perform: onImageDoubleTapped)
//                                .gesture(zoomGesture)
                                .frame(width: proxy.size.width * max(minZoomScale, zoomScale))
                                .frame(maxHeight: .infinity)
                        case .failure:
                            EmptyView()
                        case .none, .some:
                            EmptyView()
                        }
                    })
                }
            }
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imagePath: "https://cdn.espresso.economist.com/files/public/images/20230506_dap322_0.jpg")
    }
}


extension ImageDetailView {
    /// Resets the zoom scale back to 1 – the photo scale at 1x zoom
    func resetImageState() {
        withAnimation(.default) {
            zoomScale = 1
        }
    }

    /// On double tap
    func onImageDoubleTapped() {
        /// Zoom the photo to 5x scale if the photo isn't zoomed in
        if zoomScale == 1 {
            withAnimation(.default) {
                zoomScale = 3
            }
        } else {
            /// Otherwise, reset the photo zoom to 1x
            resetImageState()
        }
    }

    func onZoomGestureStarted(value: MagnificationGesture.Value) {
        withAnimation(.default) {
            let delta = value / previousZoomScale
            previousZoomScale = value
            let zoomDelta = zoomScale * delta
            var minMaxScale = max(minZoomScale, zoomDelta)
            minMaxScale = min(maxZoomScale, minMaxScale)
        }
    }

    func onZoomGestureEnded(value: MagnificationGesture.Value) {
        previousZoomScale = 1
        if zoomScale <= 1 {
            resetImageState()
        } else if zoomScale > 3 {
            zoomScale = 3
        }
    }

    var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged(onZoomGestureStarted)
            .onEnded(onZoomGestureEnded)
    }
}
