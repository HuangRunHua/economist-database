//
//  ContentView.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import SwiftUI

struct ArticleView: View {
    
    @AppStorage("FontSize") var fontSize: Int = 0
    
    @State var translateText: String?
    
    @State private var showingPopover = false
    
    @State private var showLinkContent = false
    @State private var selectedLink: URL?
    
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
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text(self.currentArticle.hashTag.uppercased())
                            .font(Font.custom("Georgia", size: 15))
                            .foregroundColor(.hashtagColor)
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = self.currentArticle.hashTag
                                })
                            }))
                        Spacer()
                    }
                    HStack {
                        Text(self.currentArticle.title)
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
                        Text(self.currentArticle.subtitle)
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
                AsyncImage(url: self.coverImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(self.currentArticle.coverImageWidth!/self.currentArticle.coverImageHeight!, contentMode: .fit)
                            .padding(.bottom, 7)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(self.currentArticle.coverImageWidth!/self.currentArticle.coverImageHeight!, contentMode: .fit)
                            .foregroundColor(.secondary)
                            .padding(.bottom,7)
                    @unknown default:
                        EmptyView()
                    }
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
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(currentArticle: Article(
            id: 0, title: "A Murder Roils the Cycling World", subtitle: "In gravel racing—the sport’s hottest category—the killing has exposed a lot of dirt.", coverImageURL: "https://www.economist.com/img/b/1424/801/90/media-assets/image/20221126_EUD000.jpg", contents: [Content(role: "link", link: "https://twitter.com/ShiningNikki_SN/status/1595598075732627456?s=20&t=20qUyKoFQtEylFOvbH1WkA")], coverImageWidth: 500, coverImageHeight: 500, hashTag: "A Reporter at Large", authorName: "author name", coverImageDescription: "cover image description", publishDate: "publish date"))
        .environmentObject(ModelData())
    }
}

extension ArticleView {
    @ViewBuilder
    private func transmitToView(_ content: Content) -> some View {
        
        switch content.contentRole {
        case .quote:
            HStack {
                Text(content.text ?? "")
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
                Text(content.text ?? "")
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
                AsyncImage(url: URL(string: content.imageURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
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
                Text(content.text ?? "")
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
                Text(content.text ?? "")
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
        }
    }
    
}
