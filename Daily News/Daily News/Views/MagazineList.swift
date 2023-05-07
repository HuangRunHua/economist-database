//
//  MagazineList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineList: View {
    
    private let databaseURL: String = "https://github.com/HuangRunHua/economist-database/raw/main/database.json"
    
    private let latestMagazineJSONURL: String = "https://github.com/HuangRunHua/economist-database/raw/main/latest.json"
    
    private let dailyBriefURLString: String = "https://www.economist.com/the-world-in-brief"
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var dailyArticleModelData: DailyArticleModelData
    @EnvironmentObject var dailyBriefModelData: DailyBriefModelData
    
    @Environment(\.colorScheme) var colorScheme
    
    var dailyBriefs: [DailyBrief] {
        return dailyBriefModelData.dailyBriefs
    }
    
    var magazineURLs: [MagazineURL] {
        return modelData.magazineURLs
    }
    
    var magazines: [Magazine] {
        return modelData.magazines.sorted(by: { $0.id > $1.id })
    }
    
    var latestArticlesList: [Article] {
        return modelData.latestArticles.sorted(by: { $0.id < $1.id })
    }
    
    /// 最新一期的杂志
    var latestMagazine: [Magazine] {
        return modelData.latestMagazine
    }
    
    var dailyArticleMagazine: [Magazine] {
        return dailyArticleModelData.latestMagazine
    }
    
    var latestMagazineURL: [LatestMagazineURL] {
        return modelData.latestMagazineURL
    }
    
    private let gridItemLayout = [GridItem(.flexible())]
    
    private let lanscapeGridItemLayout = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    
    @State private var showMagazineContents: Bool = false
    
    private let thumbnailWidth: CGFloat = 50
    private let thumbnailCornerRadius: CGFloat = 5
    private let maxMagazinesShow: Int = 5
    
    enum Tab: Int {
        case latest, daily
    }
        
    @State private var selectedTab = Tab.daily
    
    var body: some View {
        self.magazineList
    }
}

struct MagazineList_Previews: PreviewProvider {
    static var previews: some View {
        MagazineList()
            .environmentObject(ModelData())
            .environmentObject(DailyArticleModelData())
            .environmentObject(DailyBriefModelData())
    }
}

extension MagazineList {
    private var magazineList: some View {
        VStack(spacing: 0) {
            self.latestTabView
        }
    }
    
    @ViewBuilder
    private var latestArticles: some View {
        if self.modelData.latestArticles.isEmpty || self.modelData.latestArticles.count != self.latestMagazine.first?.articles.count {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    
                    NavigationLink {
                        DailyBriefList(dailyBriefs: dailyBriefs)
                    } label: {
                        if !dailyBriefs.isEmpty {
                            DailyBriefOverView(dailyBriefImagePath: dailyBriefs[1].imageURL)
                                .padding(.bottom, 3.5)
                                .padding(.top, 3.5)
                                .padding([.leading, .trailing], 7)
                        }
                    }
                    
                    ForEach(self.latestArticlesList) { article in
                        NavigationLink {
                            ArticleView(currentArticle: article)
                                .environmentObject(modelData)
                        } label: {
                            ArticleContentRow(currentArticle: article)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var magazineListRow: some View {
        LazyVGrid(columns: lanscapeGridItemLayout) {
            ForEach(magazines, id: \.identityID) { magazine in
                NavigationLink {
                    ArticleConetntsList(magazine: magazine)
                        .environmentObject(modelData)
                } label: {
                    MagazineCoverRow(magazine: magazine)
                }
            }
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    @ViewBuilder
    private var magazineTabView: some View {
        ScrollView {
            Divider()
            self.magazineListRow
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Magazines")
                    .font(Font.custom("Georgia", size: 20))
            }
        }
        .onAppear {
            self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
            self.modelData.fetchLatestMagazine()
        }
        .onChange(of: magazineURLs.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchAllMagazines()
            }
        }
    }
    
    @ViewBuilder
    private var latestTabView: some View {
        NavigationView {
            if magazines.count < self.maxMagazinesShow {
                VStack(spacing: 0) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    List {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Recent Issues".uppercased())
                                    .fontWeight(.bold)
                                    .padding([.leading, .top, .trailing])
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .bottom, spacing: 14) {
                                    ForEach(magazines.prefix(self.maxMagazinesShow), id: \.identityID) { magazine in
                                        NavigationLink {
                                            ArticleConetntsList(magazine: magazine)
                                                .environmentObject(modelData)
                                        } label: {
                                            MagazineCoverRow(magazine: magazine)
                                                .frame(width: 200)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing, .bottom])
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        
                        VStack(alignment: .leading) {
                            Text("Latest Stories".uppercased())
                                .fontWeight(.bold)
                                .padding([.leading, .top, .trailing])
                            
                            self.latestArticles
                                .padding([.leading, .trailing])
                        }
                        .padding(.bottom)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack(spacing: 0) {
                                Text("Weekly")
                                    .font(Font.custom("Georgia", size: 20))
                            }
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                self.magazineTabView
                            } label: {
                                Image(systemName: "doc.plaintext")
                            }

                        }
                    }
//                    .refreshable {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                            self.dailyBriefModelData.dailyBriefs.removeAll()
//                            self.modelData.article = nil
//                            self.modelData.magazineURLs.removeAll()
//                            self.modelData.magazines.removeAll()
//                            self.modelData.magazine = nil
//                            self.modelData.articles.removeAll()
//                            self.modelData.selectedMagazine = nil
//                            self.modelData.selectedArticle = nil
//                            self.modelData.latestMagazineURL.removeAll()
//                            self.modelData.latestMagazine.removeAll()
//                            self.modelData.latestArticles.removeAll()
//                            
////                            self.dailyBriefModelData.startLoadingBrief(urlString: self.dailyBriefURLString)
////                            self.modelData.fetchAllMagazines()
////                            self.modelData.fetchLatestMagazine()
//                            self.dailyBriefModelData.startLoadingBrief(urlString: self.dailyBriefURLString)
//                            self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
//                            self.modelData.fetchLatestEposideMagazineURL(urlString: self.latestMagazineJSONURL)
//                            self.modelData.fetchLatestMagazine()
//                        }
//                    }
                }
            }
        }
        
        #if !os(macOS)
        .navigationViewStyle(.stack)
        #endif
        .onAppear {
            DispatchQueue.main.async {
                self.dailyBriefModelData.startLoadingBrief(urlString: self.dailyBriefURLString)
                self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
                self.modelData.fetchLatestEposideMagazineURL(urlString: self.latestMagazineJSONURL)
                self.modelData.fetchLatestMagazine()
            }
        }
        .onChange(of: magazineURLs.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchAllMagazines()
            }
        }
        .onChange(of: self.latestMagazineURL.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchLatestMagazine()
            }
        }
        .onChange(of: self.latestMagazine.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchLatestArticles()
            }
        }
    }
}


