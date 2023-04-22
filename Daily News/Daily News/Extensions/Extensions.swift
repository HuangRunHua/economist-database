//
//  ColorExtensions.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI

extension Color {
    static let defaultFontColor = Color("defaultFontColor")
    static let cloudColor = Color("cloudColor")
    static let hashtagColor = Color("hashtagColor")
    static let cardColor = Color("cardColor")
    static let tabColor = Color("tabColor")
    static let dictionaryTextColor = Color("dictionaryTextColor")
}

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}

extension String {
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
    
    var pureWord: String {
        var startIndex: Index?
        for i in self {
            if i.isLetter {
                startIndex = self.firstIndex(of: i)
                break
            }
        }
        var end: Int = 0
        for i in self.reversed() {
            if i.isLetter {
                break
            }
            end += 1
        }
        
        if let startIndex {
            return String(self[self.index(startIndex, offsetBy: 0)..<self.index(endIndex, offsetBy: -end)])
        } else {
            return ""
        }
        
    }
}
