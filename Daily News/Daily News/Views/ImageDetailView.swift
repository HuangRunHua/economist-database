//
//  ImageDetailView.swift
//  Daily News
//
//  Created by Huang Runhua on 5/6/23.
//

import SwiftUI
import NukeUI

struct ImageDetailView: View {
    
    @Binding var imageURL: URL?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView(content: {
            ZoomableScrollView {
                if let imageURL = self.imageURL {
                    LazyImage(url: imageURL, content: { phase in
                        switch phase.result {
                        case .success:
                            phase.image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            EmptyView()
                        case .none, .some:
                            EmptyView()
                        }
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
        
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imageURL: .constant(URL(string: "https://cdn.espresso.economist.com/files/public/images/20230506_dap322_0.jpg")))
    }
}


struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content

    init(@ViewBuilder content: () -> Content) {
       self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        // set up the UIScrollView
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator  // for viewForZooming(in:)
        scrollView.maximumZoomScale = 20
        scrollView.minimumZoomScale = 1
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        // create a UIHostingController to hold our SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        scrollView.addSubview(hostedView)

        return scrollView
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content))
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        context.coordinator.hostingController.rootView = self.content
        assert(context.coordinator.hostingController.view.superview == uiView)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
    }
}
