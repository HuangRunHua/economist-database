//
//  DailyBriefArticleView.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import SwiftUI
import NukeUI

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
    @State private var showDetailImage: Bool = false
    @State private var detailImageURL: URL? = nil
    
    // MARK: PDF Share
    @State private var pdfURL: URL?
    @State private var showShareSheet: Bool = false
    
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
                    LazyImage(url: imageURL, content: { phase in
                        switch phase.result {
                        case .success:
                            phase.image?
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.bottom, 7)
                                .onTapGesture {
                                    self.detailImageURL = imageURL
                                }
                        case .failure:
                            Rectangle()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .padding(.bottom,7)
                        case .none, .some:
                            Rectangle()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .padding(.bottom,7)
                        }
                    })
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    exportPDF(title: self.dailyBrief.headline ?? "The world in brief") {
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

struct DailyBriefArticleView_Previews: PreviewProvider {
    static var previews: some View {
//        DailyBriefArticleView(dailyBrief: DailyBrief(id: 0, headline: "Peace remains elusive in Sudan", imageURL: "https://cdn.espresso.economist.com/files/public/images/20230506_dap334.jpg", contents: [
//            "Sudan’s latest “ceasefire” was meant to begin overnight on Thursday. Brokered by Salva Kiir, the president of South Sudan, a neighbouring country, it is supposed to last seven days. That would be the longest truce yet and could even lead to peace talks in Juba, the South Sudanese capital. But Sudan’s beleaguered civilians are probably not holding their breath.",
//            "Neither of the armed factions which have been battling since April 15th has shown willingness to cede ground. The national army, led by General Abdel Fattah al-Burhan, believes it will soon regain control of Khartoum, Sudan’s capital and site of much of the fighting. It has more troops, heavier weaponry and can count on military support from Egypt."
//        ]))
        
        DailyBriefArticleView(dailyBrief: DailyBrief(id: 0, contents:
            [DailyBriefArticleFormat(role: "body", body: "Volodymyr Zelensky, Ukraine’s president, gave a speech at the International Criminal Court in The Hague during an unannounced visit to the Netherlands. Mr Zelensky accused Russia of committing more than 6,000 war crimes in April alone. In March the ICC issued an arrest warrant for Russia’s president on war crimes charges. Meanwhile, Russia accused America of planning a drone attack on the Kremlin and said that Ukraine had acted on American orders. Both governments have denied these claims. The allegations came after Russia launched strikes on Ukrainian cities."),
             DailyBriefArticleFormat(role: "body", body: "Four members of the Proud Boys, an American far-right group, were convicted of seditious conspiracy for their role in the Capitol riot on January 6th 2021. A jury in Washington said that the men, including the group’s former leader, Enrique Tarrio, had planned the riot to keep Donald Trump in power. It is the last of three sedition cases against key figures involved in the riot."),
             DailyBriefArticleFormat(role: "image", imageURL: "https://cdn.espresso.economist.com/files/public/images/XwordGrid_11_656_16.jpg")
            ]))
    }
}

extension DailyBriefArticleView {
    @MainActor
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
            LazyImage(url: URL(string: content.imageURL ?? ""), content: { phase in
                switch phase.result {
                case .success:
                    phase.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            self.detailImageURL = URL(string: content.imageURL ?? "")
                        }
                case .failure:
                    EmptyView()
                case .none, .some:
                    EmptyView()
                }
            })
        }
    }
    
}
