//
//  DictionaryText.swift
//  OpenDictionary
//
//  Created by Huang Runhua on 4/22/23.
//

import SwiftUI

struct DictionaryText: View {
    var text: String
    var color: Color
        
    init(_ text: String, color: Color = Color.dictionaryTextColor) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
    }
}

struct DictionaryText_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryText("One of the key issues with current ai systems is that they are primarily black boxes, often unreliable and hard to interpret, and at risk of getting out of control. ")
    }
}
