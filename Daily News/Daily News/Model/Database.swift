//
//  Database.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import Foundation
import SwiftUI

struct Magazine: Codable, Equatable {
    static func == (lhs: Magazine, rhs: Magazine) -> Bool {
        return lhs.identityID == rhs.identityID
    }
    
    var identityID: UUID {
        return UUID(uuidString: self.id) ?? UUID()
    }
    var id: String
    var coverStory: String
    var coverImageURL: String
    var coverImageWidth: Double
    var coverImageHeight: Double
    var articles: [ArticleURL]
    var date: String
}

struct ArticleURL: Identifiable, Codable {
    var id: Int
    var articleURL: String
}

struct MagazineURL: Identifiable, Codable {
    var id: Int
    var magazineURL: String
}

struct LatestMagazineURL: Codable {
    var magazineURL: String
}
