//
//  Article.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import Foundation

struct Article: Identifiable, Codable {
    var id: Int
    var title: String
    var subtitle: String
    var coverImageURL: String?
    var contents: [ArticleContent]
    var coverImageWidth: Double?
    var coverImageHeight: Double?
    var hashTag: String
    var authorName: String
    var coverImageDescription: String?
    var publishDate: String
}
