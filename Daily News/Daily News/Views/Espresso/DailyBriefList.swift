//
//  DailyBriefList.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import SwiftUI

struct DailyBriefList: View {
    
    let dailyBriefs: [DailyBrief]
    
    private let portraitGridItemLayoutiPad = [GridItem(.flexible(), spacing: 3.5), GridItem(.flexible(), spacing: 3.5)]
    private let lanscapeGridItemLayoutiPad = [GridItem(.flexible(), spacing: 3.5), GridItem(.flexible(), spacing: 3.5), GridItem(.flexible(), spacing: 3.5)]
    
    // MARK: For Orientation
    @State private var articleContentID: UUID = UUID()
    @State private var orientation: UIDeviceOrientation = .portrait
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            if UIDevice.isIPad {
                if orientation.isLandscape {
                    LazyVGrid(columns: lanscapeGridItemLayoutiPad) {
                        ForEach(self.dailyBriefs, id: \.id) { dailyBrief in
                            NavigationLink {
                                DailyBriefArticleView(dailyBrief: dailyBrief)
                            } label: {
                                DailyBriefRow(currentBrief: dailyBrief)
                                    .frame(width: UIScreen.main.bounds.width/3-14)
                                    .id(self.articleContentID)
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: portraitGridItemLayoutiPad) {
                        ForEach(self.dailyBriefs, id: \.id) { dailyBrief in
                            NavigationLink {
                                DailyBriefArticleView(dailyBrief: dailyBrief)
                            } label: {
                                DailyBriefRow(currentBrief: dailyBrief)
                                    .frame(width: UIScreen.main.bounds.width/2-14)
                                    .id(self.articleContentID)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    ForEach(self.dailyBriefs, id: \.id) { dailyBrief in
                        NavigationLink {
                            DailyBriefArticleView(dailyBrief: dailyBrief)
                        } label: {
                            DailyBriefRow(currentBrief: dailyBrief)
                        }
                    }
                }
            }
            
            
        }
        .padding([.leading, .trailing])
        .navigationTitle("The world in brief")
        .onRotate { newOrientation in
            orientation = newOrientation
            self.articleContentID = UUID()
        }
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        if geo.size.width > geo.size.height {
                            self.orientation = .landscapeLeft
                        } else {
                            self.orientation = .portrait
                        }
                    }
            }
        }
    }
}

struct DailyBriefList_Previews: PreviewProvider {
    static var previews: some View {
        DailyBriefList(dailyBriefs: [
            DailyBrief(id: 0, contents: [
                DailyBriefArticleFormat(role: "body", body: "Volodymyr Zelensky, Ukraine’s president, gave a speech at the International Criminal Court in The Hague during an unannounced visit to the Netherlands. Mr Zelensky accused Russia of committing more than 6,000 war crimes in April alone. In March the ICC issued an arrest warrant for Russia’s president on war crimes charges. Meanwhile, Russia accused America of planning a drone attack on the Kremlin and said that Ukraine had acted on American orders. Both governments have denied these claims. The allegations came after Russia launched strikes on Ukrainian cities."),
                DailyBriefArticleFormat(role: "body", body: "Four members of the Proud Boys, an American far-right group, were convicted of seditious conspiracy for their role in the Capitol riot on January 6th 2021. A jury in Washington said that the men, including the group’s former leader, Enrique Tarrio, had planned the riot to keep Donald Trump in power. It is the last of three sedition cases against key figures involved in the riot.")]),
            DailyBrief(id: 1, headline: "Weekly crossword", imageURL: "https://cdn.espresso.economist.com/files/public/images/EspressoCrossword_30.jpg", contents: [
                DailyBriefArticleFormat(role: "body", body: "Sudan’s latest “ceasefire” was meant to begin overnight on Thursday. Brokered by Salva Kiir, the president of South Sudan, a neighbouring country, it is supposed to last seven days. That would be the longest truce yet and could even lead to peace talks in Juba, the South Sudanese capital. But Sudan’s beleaguered civilians are probably not holding their breath."),
                DailyBriefArticleFormat(role: "image", imageURL: "https://cdn.espresso.economist.com/files/public/images/XwordGrid_11_656_16.jpg")
            ])
        ])
    }
}
