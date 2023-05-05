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
    var contents: [String]
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
                dailyBriefNote.contents.append(text)
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
                    dailyBrief.contents.append(try content.text())
                }
                
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
