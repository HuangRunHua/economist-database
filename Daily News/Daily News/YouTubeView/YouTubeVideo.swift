//
//  YouTubeVideo.swift
//  Daily News
//
//  Created by Huang Runhua on 4/25/23.
//

import SwiftUI
import WebKit

struct YouTubeVideo: UIViewRepresentable {
    
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsLinkPreview = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            return
        }
        
        let request = URLRequest(url: youtubeURL)
        uiView.load(request)
    }
}
