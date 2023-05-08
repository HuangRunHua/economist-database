//
//  ContentView.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import SwiftUI
import NukeUI

struct ArticleView: View {
    
    @AppStorage("FontSize") var fontSize: Int = 0
    
    @State var translateText: String?
    
    @State private var showingPopover = false
    
    @State private var showLinkContent = false
    @State private var selectedLink: URL?
    
    // MARK: PDF Share
    @State private var pdfURL: URL?
    @State private var showShareSheet: Bool = false
    
    var currentArticle: Article
    
    var coverImageURL: URL? {
        if let coverImageURL = self.currentArticle.coverImageURL {
            return URL(string: coverImageURL)
        } else {
            return nil
        }
    }
    
    @EnvironmentObject var modelData: ModelData
    
    private let maxWidth: CGFloat = 800
    
    @State private var showingSheet = false
    @State private var selectedWord: String = ""
    @State private var showDetailImage: Bool = false
    @State private var detailImageURL: URL? = nil
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        DictionaryText(self.currentArticle.hashTag, color: .hashtagColor)
                            .modifier(DictionaryTextModifier())
                            .font(Font.custom("Georgia", size: 17))
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = self.currentArticle.hashTag
                                })
                            }))
                        Spacer()
                    }
                    HStack {
                        DictionaryText(self.currentArticle.title)
                            .modifier(DictionaryTextModifier())
                            .font(Font.custom("Georgia", size: 30))
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = self.currentArticle.title
                                })
                            }))
                        Spacer()
                    }
                }
                if self.currentArticle.subtitle != "" {
                    HStack {
                        DictionaryText(self.currentArticle.subtitle)
                            .modifier(DictionaryTextModifier())
                            .font(Font.custom("Georgia", size: 20))
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = self.currentArticle.subtitle
                                })
                            }))
                        Spacer()
                    }
                }
            }
            .multilineTextAlignment(.leading)
            .padding()
            
            Divider()
            
            HStack {
                Text("By " + self.currentArticle.authorName)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                Text("·")
                Text(self.currentArticle.publishDate)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding([.bottom, .top], 7)
            
            VStack {
                if let imageURL = self.coverImageURL, let coverImageWidth = self.currentArticle.coverImageWidth, let coverImageHeight = self.currentArticle.coverImageHeight {
                    
                    LazyImage(url: imageURL, content: { phase in
                        switch phase.result {
                        case .success:
                            phase.image?
                                .resizable()
                                .aspectRatio(coverImageWidth/coverImageHeight, contentMode: .fit)
                                .padding(.bottom, 7)
                                .onTapGesture {
                                    self.detailImageURL = imageURL
                                }
                        case .failure:
                            Rectangle()
                                .aspectRatio(coverImageWidth/coverImageHeight, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .padding(.bottom,7)
                        case .none, .some:
                            Rectangle()
                                .aspectRatio(coverImageWidth/coverImageHeight, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .padding(.bottom,7)
                        }
                    })
                }
                
                if let imageDescription = self.currentArticle.coverImageDescription {
                    if imageDescription != " " && imageDescription != "" {
                        Text(imageDescription)
                            .font(Font.custom("Georgia", size: CGFloat(15 + fontSize)))
                            .foregroundColor(.gray)
                            .padding([.bottom])
                            .padding([.leading, .trailing], 7)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    if self.currentArticle.coverImageDescription != "" {
                                        self.translateText = self.currentArticle.coverImageDescription
                                    }
                                })
                            }))
                    }
                }
            }
            
            ForEach(self.currentArticle.contents) { content in
                VStack(alignment: .leading) {
                    self.transmitToView(content)
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
        }
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .translateSheet($translateText)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        if self.fontSize > 0 {
                            self.fontSize -= 1
                        }
                    } label: {
                        Label("Smaller size", systemImage: "textformat.size.smaller")
                    }

                    Button {
                        if self.fontSize < 7 {
                            self.fontSize += 1
                        }
                    } label: {
                        Label("Larger size", systemImage: "textformat.size.larger")
                    }
                } label: {
                    Image(systemName: "textformat.size")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    exportPDF(title: self.currentArticle.title) {
                        self
                    } completion: { status, url in
                        if let url = url, status {
                            self.pdfURL = url
                            self.showShareSheet.toggle()
                        } else {
                            print("Failed to render PDF")
                        }
                    }

                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
        }
        .onOpenURL { url in
            if let selectedWord = self.parseURL(url: url) {
                self.selectedWord = selectedWord
            }
        }
        .onChange(of: self.selectedWord, perform: { newValue in
            if self.selectedWord != "" {
                self.showingSheet.toggle()
            }
        })
        .onChange(of: self.detailImageURL, perform: { newValue in
            if self.detailImageURL != nil {
                self.showDetailImage.toggle()
            }
        })
        .sheet(isPresented: $showingSheet, onDismiss: {
            self.selectedWord = ""
        }) {
            if self.selectedWord != "" {
                DictionarySearchViewController(word: self.selectedWord)
            }
        }
        .fullScreenCover(isPresented: $showDetailImage, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.detailImageURL = nil
            }
        }) {
            ImageDetailView(imageURL: self.$detailImageURL)
        }
        .sheet(isPresented: Binding(
            get: { showShareSheet },
            set: { showShareSheet = $0 })) {
            pdfURL = nil
        } content: {
            if let pdfURL {
                ShareSheet(urls: [pdfURL])
            }
        }
    }
    
    private func parseURL(url: URL) -> String? {
        let string = url.absoluteString
        if let keyword = string.split(separator: "//").last {
            if keyword != "" {
                return String(keyword)
            }
        }
        return nil
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(currentArticle: Article(
            id: 0,
            title: "A Murder Roils the Cycling World",
            subtitle: "In gravel racing—the sport’s hottest category—the killing has exposed a lot of dirt.",
            coverImageURL: "https://www.economist.com/img/b/1424/801/90/media-assets/image/20221126_EUD000.jpg",
            contents: [Content(role: "video", link: "https://www.youtube.com/watch?v=aZ-FipkmTMg")],
            coverImageWidth: 500,
            coverImageHeight: 500,
            hashTag: "A Reporter at Large",
            authorName: "author name",
            coverImageDescription: "cover image description", publishDate: "publish date"))
        .environmentObject(ModelData())
    }
}

extension ArticleView {
    @ViewBuilder
    private func transmitToView(_ content: Content) -> some View {
        
        switch content.contentRole {
        case .quote:
            HStack {
                DictionaryText(content.text ?? "")
                    .modifier(DictionaryTextModifier())
                    .font(Font.custom("Georgia", size: CGFloat(17 + fontSize)))
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing])
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))

                Spacer()
            }
            .frame(maxWidth: self.maxWidth)
            
        case .body:
            HStack {
                DictionaryText(content.text ?? "")
                    .modifier(DictionaryTextModifier())
                    .font(Font.custom("Georgia", size: CGFloat(17 + fontSize)))
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))
                Spacer()
            }
            .frame(maxWidth: self.maxWidth)
            
        case .image:
            VStack {
                LazyImage(url: URL(string: content.imageURL ?? ""), content: { phase in
                    switch phase.result {
                    case .success:
                        phase.image?
                            .resizable()
                            .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
                            .onTapGesture {
                                self.detailImageURL = URL(string: content.imageURL ?? "")
                            }
                    case .failure:
                        Rectangle()
                            .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
                            .foregroundColor(.secondary)
                    case .none, .some:
                        Rectangle()
                            .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
                            .foregroundColor(.secondary)
                    }
                })
                if let contentImageDescription = content.imageDescription {
                    if contentImageDescription != " " && contentImageDescription != "" {
                        Text(contentImageDescription)
                            .font(Font.custom("Georgia", size: CGFloat(15 + fontSize)))
                            .foregroundColor(.gray)
                            .padding([.bottom])
                            .padding([.leading, .trailing], 7)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    if let imageDescription = content.imageDescription {
                                        self.translateText = imageDescription
                                    }
                                })
                            }))
                    }
                }
                
            }
        case .head:
            HStack {
                DictionaryText(content.text ?? "")
                    .modifier(DictionaryTextModifier())
                    .font(Font.custom("Georgia", size: CGFloat(22 + fontSize)))
                    .fontWeight(.bold)
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))
                Spacer()
            }
            .frame(maxWidth: self.maxWidth)
        case .second:
            HStack {
                DictionaryText(content.text ?? "")
                    .modifier(DictionaryTextModifier())
                    .font(Font.custom("Georgia", size: CGFloat(20 + fontSize)))
                    .fontWeight(.bold)
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))
                Spacer()
            }
            .frame(maxWidth: self.maxWidth)
        case .link:
            EmptyView()
        case .video:
            if let videoLink = content.link {
                YouTubeVideoView(youtubeVideoPath: videoLink)
            }
        }
    }
    
}
