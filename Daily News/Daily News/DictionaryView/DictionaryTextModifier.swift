//
//  DictionaryTextModifier.swift
//  OpenDictionary
//
//  Created by Huang Runhua on 4/22/23.
//

import SwiftUI

protocol TextModifier {
    associatedtype Body : View
    func body(text: DictionaryText, color: Color) -> Self.Body
}

extension DictionaryText {
    func modifier<M>(_ modifier: M) -> some View where M: TextModifier {
        modifier.body(text: self, color: color)
    }
}


struct DictionaryTextModifier: TextModifier {

    func body(text: DictionaryText, color: Color) -> some View {
        let words = text.text.split(separator: " ")
        var output: Text = Text("")
        for word in words {
            output = output +
            Text(String(word)) {
                if String(word).pureWord != "" {
                    let specialLetter: [String] = ["\"", "'", "“", "”", "’", "—"]
                    if String(word).pureWord.contains(where: { specialLetter.contains( String($0) ) }) {
                        $0.link = URL(string: "dictionarytext://" + String(word).letters)
                    } else {
                        $0.link = URL(string: "dictionarytext://" + String(word).pureWord)
                    }
                }
                $0.foregroundColor = color
            } + Text(" ")
        }
        return output
    }
}
