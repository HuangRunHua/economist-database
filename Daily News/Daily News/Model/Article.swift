//
//  Article.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import Foundation

struct Article: Identifiable, Codable {
    var id: UUID {
        return UUID()
    }
    var title: String
    var subtitle: String
    var coverImageURL: String?
    var contents: [Content]
    var coverImageWidth: Double?
    var coverImageHeight: Double?
    var hashTag: String
    var authorName: String
    var coverImageDescription: String
    var publishDate: String
}
