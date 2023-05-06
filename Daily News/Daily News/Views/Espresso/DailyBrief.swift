//
//  DailyBrief.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import Foundation
import SwiftSoup

struct DailyBrief {
    var id: Int
    var headline: String?
    var imageURL: String?
//    var contents: [String]
    var contents: [DailyBriefArticleFormat]
}

struct DailyBriefArticleFormat: Identifiable {
    var id: UUID {
        return UUID()
    }
    var role: String
    var body: String?
    var imageURL: String?
    
    public enum Role: String {
        case body = "body"
        case image = "image"
    }
    
    var contentRole: Role {
        return Role(rawValue: role) ?? .body
    }
}

struct BriefParser {
    
    static func fetchJSON(sourcePageString: String) -> [DailyBrief] {
        
        var dailyBriefs: [DailyBrief] = []
        
        do {
            let doc: Document = try SwiftSoup.parse(sourcePageString)
            let briefNotes = try doc.select("[class=_gobbet]")
            var dailyBriefNote: DailyBrief = DailyBrief(id: 0, contents: [])
            for brietNote in briefNotes {
                let text = try brietNote.text()
                let dailyBriefArticleFormat = DailyBriefArticleFormat(role: "body", body: text)
                dailyBriefNote.contents.append(dailyBriefArticleFormat)
            }
            
            dailyBriefs.append(dailyBriefNote)
            
            // briefArticles.count = 7
            let briefArticles = try doc.select("[class=_article ds-layout-grid]")
            for index_briefArticle in zip(1..<briefArticles.count+1, briefArticles) {
                var dailyBrief: DailyBrief = DailyBrief(id: index_briefArticle.0, contents: [])
                dailyBrief.imageURL = try index_briefArticle.1.select("[itemProp=url]").attr("content")
                dailyBrief.headline = try index_briefArticle.1.select("[class=_headline]").text()
                // contents = [<p></p>, <p></p>]
                let contents = try index_briefArticle.1.select("[class= css-111mrt0 etrcux30]").select("p")
                for content in contents {
                    let text = try content.text()
                    let dailyBriefArticleFormat = DailyBriefArticleFormat(role: "body", body: text)
                    dailyBrief.contents.append(dailyBriefArticleFormat)
                }
                // In case there may be an image
                let inlineImageURL = try index_briefArticle.1.select("[class=_inline-image]").select("[itemProp=url]").attr("content")
                let dailyBriefArticleFormat = DailyBriefArticleFormat(role: "image", imageURL: inlineImageURL)
                dailyBrief.contents.append(dailyBriefArticleFormat)
                
                dailyBriefs.append(dailyBrief)
            }
            
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        return dailyBriefs
    }
}
