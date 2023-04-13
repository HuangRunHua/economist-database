//
//  Contents.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import SwiftUI

struct Content: Identifiable, Codable {
    var id: UUID{
        return UUID()
    }
    /// For easy implement, the role now only contains `body` and `image`
    var role: String
    var text: String?
    /// This URL string is only for image.
    var imageURL: String?
    var imageWidth: Double?
    var imageHeight: Double?
    var imageDescription: String?
    var link: String?
    
    public enum Role: String {
        case quote = "quote"
        case body = "body"
        case image = "image"
        case head = "head"
        case second = "second"
        case link = "link"
    }
    
    var contentRole: Role {
        return Role(rawValue: role) ?? .body
    }
}
