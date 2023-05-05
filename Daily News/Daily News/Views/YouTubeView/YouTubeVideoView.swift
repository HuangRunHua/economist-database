//
//  YouTubeVideoView.swift
//  Daily News
//
//  Created by Huang Runhua on 4/25/23.
//

import SwiftUI

struct YouTubeVideoView: View {
    
    let youtubeVideoPath: String
    @State private var youtubeVideoID: String? = nil
    
    var body: some View {
        VStack {
            if let youtubeVideoID {
                VStack {
                    YouTubeVideo(videoID: youtubeVideoID)
                        .aspectRatio(4/3, contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.boundingColor, lineWidth: 2)
                )
                .cornerRadius(0)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            self.youtubeVideoID = paraseYoutubeID(source: self.youtubeVideoPath)
        }
    }
    
    func paraseYoutubeID(source link: String) -> String? {
        if let equalIndex = link.firstIndex(of: "=") {
            return String(link[link.index(equalIndex, offsetBy: 1)..<link.endIndex])
        }
        return nil
    }
}


struct YouTubeVideoView_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeVideoView(youtubeVideoPath: "https://www.youtube.com/watch?v=aZ-FipkmTMg")
    }
}
