//
//  YouTubeVideoView.swift
//  Daily News
//
//  Created by Huang Runhua on 4/25/23.
//

import SwiftUI

struct YouTubeVideoView: View {
    
    let youtubeVideoID: String
    
    var body: some View {
        VStack {
            YouTubeVideo(videoID: youtubeVideoID)
                .aspectRatio(4/3, contentMode: .fit)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.boundColor, lineWidth: 2)
        )
        .cornerRadius(0)
    }
}


struct YouTubeVideoView_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeVideoView(youtubeVideoID: "3tJUflhYIpo")
    }
}
