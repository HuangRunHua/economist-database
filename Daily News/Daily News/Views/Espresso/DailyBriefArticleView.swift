//
//  DailyBriefArticleView.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import SwiftUI

struct DailyBriefArticleView: View {
    
    let dailyBrief: DailyBrief
    
    @AppStorage("FontSize") var fontSize: Int = 0
        
    @State var translateText: String?
    
    @State private var showingPopover = false
    
    @State private var showLinkContent = false
    @State private var selectedLink: URL?
    
    var coverImageURL: URL? {
        if let coverImageURL = self.dailyBrief.imageURL {
            return URL(string: coverImageURL)
        } else {
            return nil
        }
    }
    
    private let maxWidth: CGFloat = 800
    
    @State private var showingSheet = false
    @State private var selectedWord: String = ""
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        DictionaryText("Espresso", color: .hashtagColor)
                            .modifier(DictionaryTextModifier())
                            .font(Font.custom("Georgia", size: 17))
                            .foregroundColor(.hashtagColor)
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = "Espresso"
                                })
                            }))
                        Spacer()
                    }
                    HStack {
                        DictionaryText(self.dailyBrief.headline ?? "The world in brief")
                            .modifier(DictionaryTextModifier())
                            .font(Font.custom("Georgia", size: 30))
                            .textSelection(.enabled)
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Translate", action: {
                                    self.translateText = self.dailyBrief.headline
                                })
                            }))
                        Spacer()
                    }
                }
            }
            .multilineTextAlignment(.leading)
            .padding()
            
            VStack {
                if let imageURL = self.coverImageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.bottom, 7)
                        case .empty, .failure:
                            Rectangle()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .padding(.bottom,7)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            
            ForEach(self.dailyBrief.contents, id: \.id) { content in
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
        .sheet(isPresented: $showingSheet) {
            if self.selectedWord != "" {
                DictionarySearchViewController(word: self.selectedWord)
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

struct DailyBriefArticleView_Previews: PreviewProvider {
    static var previews: some View {
//        DailyBriefArticleView(dailyBrief: DailyBrief(id: 0, headline: "Peace remains elusive in Sudan", imageURL: "https://cdn.espresso.economist.com/files/public/images/20230506_dap334.jpg", contents: [
//            "Sudan’s latest “ceasefire” was meant to begin overnight on Thursday. Brokered by Salva Kiir, the president of South Sudan, a neighbouring country, it is supposed to last seven days. That would be the longest truce yet and could even lead to peace talks in Juba, the South Sudanese capital. But Sudan’s beleaguered civilians are probably not holding their breath.",
//            "Neither of the armed factions which have been battling since April 15th has shown willingness to cede ground. The national army, led by General Abdel Fattah al-Burhan, believes it will soon regain control of Khartoum, Sudan’s capital and site of much of the fighting. It has more troops, heavier weaponry and can count on military support from Egypt."
//        ]))
        
        DailyBriefArticleView(dailyBrief: DailyBrief(id: 0, contents: [
            DailyBriefArticleFormat(role: "body", body: "Volodymyr Zelensky, Ukraine’s president, gave a speech at the International Criminal Court in The Hague during an unannounced visit to the Netherlands. Mr Zelensky accused Russia of committing more than 6,000 war crimes in April alone. In March the ICC issued an arrest warrant for Russia’s president on war crimes charges. Meanwhile, Russia accused America of planning a drone attack on the Kremlin and said that Ukraine had acted on American orders. Both governments have denied these claims. The allegations came after Russia launched strikes on Ukrainian cities."),
            DailyBriefArticleFormat(role: "body", body: "Four members of the Proud Boys, an American far-right group, were convicted of seditious conspiracy for their role in the Capitol riot on January 6th 2021. A jury in Washington said that the men, including the group’s former leader, Enrique Tarrio, had planned the riot to keep Donald Trump in power. It is the last of three sedition cases against key figures involved in the riot.")]))
    }
}

extension DailyBriefArticleView {
    @ViewBuilder
    private func transmitToView(_ content: DailyBriefArticleFormat) -> some View {
        
        switch content.contentRole {
        case .body:
            HStack {
                DictionaryText(content.body ?? "")
                    .modifier(DictionaryTextModifier())
                    .font(Font.custom("Georgia", size: CGFloat(17 + fontSize)))
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.body
                        })
                    }))
                Spacer()
            }
            .frame(maxWidth: self.maxWidth)
        case .image:
            AsyncImage(url: URL(string: content.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .empty, .failure:
                    EmptyView()
//                    Rectangle()
//                        .aspectRatio((content.imageWidth!)/(content.imageHeight!), contentMode: .fit)
//                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
    
}
