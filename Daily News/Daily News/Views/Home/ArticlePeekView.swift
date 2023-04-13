//
//  ArticlePeekView.swift
//  Daily News
//
//  Created by Huang Runhua on 11/30/22.
//

import SwiftUI

struct ArticlePeekView: View {
    
    var currentArticle: Article
    
    var coverImageURL: URL? {
        return URL(string: self.currentArticle.coverImageURL)
    }
    
    @State private var width: CGFloat? = nil
    
    var body: some View {
        VStack {
            AsyncImage(url: self.coverImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(7)
                case .empty, .failure:
                    Rectangle()
                        .foregroundColor(.gray)
                        .aspectRatio(self.currentArticle.coverImageWidth/self.currentArticle.coverImageHeight, contentMode: .fit)
                        .cornerRadius(7)
                @unknown default:
                    EmptyView()
                }
            }
            HStack {
                Text(self.currentArticle.hashTag.uppercased())
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.hashtagColor)
                Spacer()
            }
            
            HStack {
                Text(self.currentArticle.title)
                    .font(Font.custom("Georgia", size: 25))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.defaultFontColor)
                Spacer()
            }
            
            if self.currentArticle.subtitle != "" {
                HStack {
                    Text(self.currentArticle.subtitle)
                        .font(Font.custom("Georgia", size: 18))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.defaultFontColor)
                    Spacer()
                }
                .padding(.top, -7)
            }
            Divider()
                .foregroundColor(.gray)
        }
        .padding([.leading, .trailing])
        .padding(.bottom, 3.5)
        .padding(.top, 3.5)
    }
}

struct ArticlePeekView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePeekView(currentArticle: Article(
            title: "When Migrants Become Political Pawns Clothing", subtitle: "Governor DeSantis appeared to be attempting to troll people whose magnanimity, he seemed to believe, is inversely proportional to the extent to which a given problem has an impact on their own lives.", coverImageURL: "https://media.newyorker.com/photos/635abe1ccd95e0b0aea28cec/4:3/w_560,c_limit/221107_r41294.jpg", contents: [], coverImageWidth: 500, coverImageHeight: 500, hashTag: "Comment", authorName: "author name", coverImageDescription: "cover image description", publishDate: "publish date"))
    }
}
