//
//  LinkView.swift
//  Daily News
//
//  Created by Huang Runhua on 11/29/22.
//

import SwiftUI
import UIKit
import LinkPresentation

//struct LinkView: UIViewRepresentable {
//
//    var previewURL:URL
//
//    func makeUIView(context: Context) -> LPLinkView {
//        let view = LPLinkView(url: previewURL)
//
//        let provider = LPMetadataProvider()
//        provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
//            if let md = metadata {
//                DispatchQueue.main.async {
//                    view.metadata = md
//                    view.sizeToFit()
//                }
//            }
//            else if error != nil {
//                let md = LPLinkMetadata()
//                md.title = ""
//                view.metadata = md
//                view.sizeToFit()
//            }
//        }
//
//        return view
//    }
//
//    func updateUIView(_ view: LPLinkView, context: Context) {
//        // New instance for each update
//    }
//}

struct LinkView: UIViewRepresentable {
    
    var metaData: LPLinkMetadata
    
    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(metadata: metaData)
        
        
        return view
    }
    
    func updateUIView(_ view: LPLinkView, context: Context) {
        // New instance for each update
        view.metadata = metaData
    }
}


