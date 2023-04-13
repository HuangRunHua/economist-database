//
//  ArticleContentRow.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI

struct ArticleContentRow: View {
    
    var currentArticle: Article
    
    var coverImageURL: URL? {
        if let coverImageURL = self.currentArticle.coverImageURL {
            return URL(string: coverImageURL)
        } else {
            return nil
        }
    }
    
    @State private var width: CGFloat? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .frame(width: self.width)
                .foregroundColor(.cardColor)
                .shadow(radius: 3)
            VStack {
                HStack(alignment: .top, spacing: 7) {
                    VStack(alignment: .leading) {
                        Text(currentArticle.title)
                            .font(Font.custom("Georgia", size: 20))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.defaultFontColor)
                        Spacer()
                    }
                    Spacer()
                    AsyncImage(url: self.coverImageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(7)
                        case .empty, .failure:
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 130, height: 130)
                                .cornerRadius(7)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                Divider()
                HStack {
                    Text(currentArticle.authorName)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .padding()
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: WidthKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(WidthKey.self) {
                self.width = $0
            }
        }
        .frame(height: 200)
        .padding(.bottom, 3.5)
        .padding(.top, 3.5)
        .padding([.leading, .trailing], 7)
    }
}

struct ArticleContentRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleContentRow(currentArticle: Article(
            title: "When Migrants Become Political Pawns Clothing", subtitle: "Governor DeSantis appeared to be attempting to troll people whose magnanimity, he seemed to believe, is inversely proportional to the extent to which a given problem has an impact on their own lives.", coverImageURL: "https://media.newyorker.com/photos/635abe1ccd95e0b0aea28cec/4:3/w_560,c_limit/221107_r41294.jpg", contents: [], coverImageWidth: 500, coverImageHeight: 500, hashTag: "Comment", authorName: "author name", coverImageDescription: "cover image description", publishDate: "publish date"))
    }
}
