//
//  Daily_NewsApp.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import SwiftUI

@main
struct Daily_NewsApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var dailyArticleModelData = DailyArticleModelData()
    @StateObject private var dailyBriefModelData = DailyBriefModelData()
    
    var body: some Scene {
        WindowGroup {
            MagazineList()
                .environmentObject(modelData)
                .environmentObject(dailyArticleModelData)
                .environmentObject(dailyBriefModelData)
//            ImageDetailView(imagePath: "https://www.economist.com/cdn-cgi/image/width=1424,quality=80,format=auto/media-assets/image/20230506_LDD001.jpg")
        }
    }
}
