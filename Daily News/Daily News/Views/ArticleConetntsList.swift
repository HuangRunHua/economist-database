//
//  ArticleConetntsList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI
import NukeUI

struct ArticleConetntsList: View {
    
    @EnvironmentObject var modelData: ModelData
    var magazine: Magazine
    var coverImageURL: URL? {
        return URL(string: self.magazine.coverImageURL)
    }
    
    var articles: [Article] {
        return modelData.articles.sorted(by: { $0.id < $1.id })
    }
    
    @State private var loadArticleSuccessfully: Bool = false
    // MARK: For Orientation
    @State private var articleContentID: UUID = UUID()
    
    var body: some View {
        GeometryReader(content: { geo in
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        if geo.size.width > geo.size.height {
                            LazyImage(url: self.coverImageURL, content: { phase in
                                switch phase.result {
                                case .success:
                                    phase.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(radius: 7, x: 0, y: 5)
                                        .frame(maxWidth: UIDevice.isIPad ? geo.size.width/2: .infinity)
                                case .failure:
                                    Rectangle()
                                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: UIDevice.isIPad ? geo.size.width/2: .infinity)
                                case .none, .some:
                                    Rectangle()
                                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: UIDevice.isIPad ? geo.size.width/2: .infinity)
                                }
                            })
                            .cornerRadius(7)
                            .padding(.bottom)
                            .padding([.leading, .trailing], 1)
                            .shadow(radius: 7)
                        } else {
                            LazyImage(url: self.coverImageURL, content: { phase in
                                switch phase.result {
                                case .success:
                                    phase.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(radius: 7, x: 0, y: 5)
                                case .failure:
                                    Rectangle()
                                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                                        .foregroundColor(.secondary)
                                case .none, .some:
                                    Rectangle()
                                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                                        .foregroundColor(.secondary)
                                }
                            })
                            .cornerRadius(7)
                            .padding(.bottom)
                            .padding([.leading, .trailing], 1)
                            .shadow(radius: 7)
                        }
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
                    
                    if modelData.articles.count != self.magazine.articles.count {
                        ProgressView()
                    } else {
                        ForEach(articles) { article in
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
    //                            .frame(maxWidth: UIDevice.isIPad ? UIScreen.main.bounds.width/1.3: .infinity)
                                .frame(maxWidth: UIDevice.isIPad ? geo.size.width/1.3: .infinity)
                                .id(self.articleContentID)
                                .padding()
                            }
                        }
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        })
        .onAppear {
            if !self.loadArticleSuccessfully {
                modelData.selectedMagazine = self.magazine
                modelData.fetchAllArticles()
            }
        }
        .onChange(of: self.articles.count) { newValue in
            self.loadArticleSuccessfully = newValue > 0 ? true: false
        }
        .onRotate { _ in
            self.articleContentID = UUID()
        }
        
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
                    ArticleURL(id: 0, articleURL: "https://github.com/HuangRunHua/economist-database/raw/main/articles/2023-01-07/who-is-andrew-tate-the-misogynist-hero-to-millions-of-young-men.json"),
                    ArticleURL(id: 1, articleURL: "https://github.com/HuangRunHua/economist-database/raw/main/articles/2023-01-07/pele-went-from-poverty-to-football-superstardom.json")
                ],
                date: "Oct 3rh 2022"))
        .environmentObject(ModelData())
    }
}
