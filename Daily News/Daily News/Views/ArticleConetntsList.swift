//
//  ArticleConetntsList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI

struct ArticleConetntsList: View {
    
    @EnvironmentObject var modelData: ModelData
    var magazine: Magazine
    var coverImageURL: URL? {
        return URL(string: self.magazine.coverImageURL)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                AsyncImage(url: self.coverImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 7, x: 0, y: 5)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(7)
                .padding(.bottom)
                .padding([.leading, .trailing], 1)
                .shadow(radius: 7)
                VStack {
                    Text(self.magazine.date)
                        .font(Font.custom("Georgia", size: 30))
                        .fontWeight(.medium)
                    Text(self.magazine.coverStory)
                        .font(Font.custom("Georgia", size: 17))
                }
                .padding([.leading, .trailing])
            }
            .padding([.bottom])
            
            if modelData.articles.isEmpty {
                ProgressView()
            } else {
                ForEach(modelData.articles) { article in
                    NavigationLink {
                        ArticleView(currentArticle: article)
                            .environmentObject(modelData)
                    } label: {
                        VStack(spacing: 10) {
                            Text(article.title)
                                .font(Font.custom("Georgia", size: 25))
                                .foregroundColor(.defaultFontColor)
                                .multilineTextAlignment(.center)
                            Text(article.hashTag.uppercased())
                                .font(Font.custom("Georgia", size: 17))
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            modelData.selectedMagazine = self.magazine
            modelData.fetchAllArticles()
        }
//        .interactiveDismissDisabled()
        
    }
}

struct ArticleConetntsList_Previews: PreviewProvider {
    static var previews: some View {
        ArticleConetntsList(
            magazine: Magazine(
                id: "111111-1111-1111-111111111111",
                coverStory: "cover story",
                coverImageURL: "https://media.newyorker.com/photos/632de17e882c6ff52b2d3b1f/master/w_380,c_limit/2022_10_03.jpg",
                coverImageWidth: 555,
                coverImageHeight: 688,
                articles: [
                    ArticleURL(id: 0, articleURL: "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022-11-14/eposide/emma-thompsons-third-act.json")
                ],
                date: "Oct 3rh 2022"))
        .environmentObject(ModelData())
    }
}
