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
    // MARK: For Orientation
    @State private var articleContentID: UUID = UUID()
    
    // MARK: For Print
    @State private var screenWidth: CGFloat? = nil
    
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
        
        GeometryReader(content: { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            DictionaryText(self.currentArticle.hashTag, color: .hashtagColor)
                                .modifier(DictionaryTextModifier())
                                .font(Font.custom("Georgia", size: 17))
                                .textSelection(.enabled)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.hashTag
                                    })
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
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.title
                                    })
                                    Button("Translate", action: {
                                        self.translateText = self.currentArticle.title
                                    })
                                }))
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    }
                    if self.currentArticle.subtitle != "" {
                        HStack {
                            DictionaryText(self.currentArticle.subtitle)
                                .modifier(DictionaryTextModifier())
                                .font(Font.custom("Georgia", size: 20))
                                .textSelection(.enabled)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.subtitle
                                    })
                                    Button("Translate", action: {
                                        self.translateText = self.currentArticle.subtitle
                                    })
                                }))
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: UIDevice.isIPad ? geo.size.width/1.3: .infinity)
                .multilineTextAlignment(.leading)
                .padding()
                .id(self.articleContentID)
                
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
                .frame(maxWidth: UIDevice.isIPad ? geo.size.width/1.3: .infinity)
                .padding(UIDevice.isIPad ? [.leading, .trailing]: [])
                .id(self.articleContentID)
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
                .frame(maxWidth: UIDevice.isIPad ? geo.size.width/1.3: .infinity)
                .padding(UIDevice.isIPad ? [.leading, .trailing]: [])
                .id(self.articleContentID)
                
                ForEach(self.currentArticle.contents) { content in
                    VStack(alignment: .leading) {
                        self.transmitToView(content)
                    }
                }
                .frame(maxWidth: UIDevice.isIPad ? geo.size.width/1.3: .infinity)
                .padding([.leading, .trailing])
                .padding(.bottom, 12)
                .id(self.articleContentID)
            }
            .onAppear {
                self.screenWidth = geo.size.width
            }
            .onChange(of: geo.size.width) { newValue in
                self.screenWidth = newValue
            }
        })
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
                        self.printView
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
        #if !targetEnvironment(macCatalyst)
        .onOpenURL { url in
            if let selectedWord = self.parseURL(url: url) {
                self.selectedWord = selectedWord
            }
        }
        #endif
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
        .onRotate { _ in
            self.articleContentID = UUID()
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
            contents: [
                ArticleContent(role: "video", link: "https://www.youtube.com/watch?v=aZ-FipkmTMg"),
                ArticleContent(role: "body", text: "The political point-scoring also misses a bigger and more enduring problem. America’s budget deficit is set to balloon as its population ages, the cost of handouts swells and the government’s interest bill rises. We estimate that deficits could reach around 7% of gdp a year by the end of this decade—shortfalls America has not seen outside of wars and economic slumps. Worryingly, no one has a sensible plan to shrink them."),
                ArticleContent(role: "head", text: "Bust budgets"),
                ArticleContent(role: "body", text: "Governments elsewhere face similar pressures—and appear just as oblivious. Those in Europe are locked in a silly debate about how to tweak debt rules, at a time when the European Central Bank is indirectly propping up the finances of its weakest members. China’s official debt figures purport to be healthy even as the central government prepares to bail out a province. Governments are stuck in a fiscal fantasyland, and they must find a way out before disaster strikes."),
            ],
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
    private func transmitToView(_ content: ArticleContent) -> some View {
        
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
                        Button("Copy", action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = content.text
                        })
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
                        Button("Copy", action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = content.text
                        })
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
                        Button("Copy", action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = content.text
                        })
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
                        Button("Copy", action: {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = content.text
                        })
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


struct DeviceRotationViewModifier: ViewModifier {
    
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}


extension ArticleView {
    @ViewBuilder
    var printView: some View {
        if let screenWidth {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            DictionaryText(self.currentArticle.hashTag, color: .hashtagColor)
                                .modifier(DictionaryTextModifier())
                                .font(Font.custom("Georgia", size: 17))
                                .textSelection(.enabled)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.hashTag
                                    })
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
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.title
                                    })
                                    Button("Translate", action: {
                                        self.translateText = self.currentArticle.title
                                    })
                                }))
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    }
                    if self.currentArticle.subtitle != "" {
                        HStack {
                            DictionaryText(self.currentArticle.subtitle)
                                .modifier(DictionaryTextModifier())
                                .font(Font.custom("Georgia", size: 20))
                                .textSelection(.enabled)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Copy", action: {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.currentArticle.subtitle
                                    })
                                    Button("Translate", action: {
                                        self.translateText = self.currentArticle.subtitle
                                    })
                                }))
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: UIDevice.isIPad ? screenWidth/1.3: .infinity)
                .multilineTextAlignment(.leading)
                .padding()
                .id(self.articleContentID)
                
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
                .frame(maxWidth: UIDevice.isIPad ? screenWidth/1.3: .infinity)
                .padding(UIDevice.isIPad ? [.leading, .trailing]: [])
                .id(self.articleContentID)
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
                .frame(maxWidth: UIDevice.isIPad ? screenWidth/1.3: .infinity)
                .padding(UIDevice.isIPad ? [.leading, .trailing]: [])
                .id(self.articleContentID)
                
                ForEach(self.currentArticle.contents) { content in
                    VStack(alignment: .leading) {
                        self.transmitToView(content)
                    }
                }
                .frame(maxWidth: UIDevice.isIPad ? screenWidth/1.3: .infinity)
                .padding([.leading, .trailing])
                .padding(.bottom, 12)
                .id(self.articleContentID)
                
                
            }
        } else {
            EmptyView()
        }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
