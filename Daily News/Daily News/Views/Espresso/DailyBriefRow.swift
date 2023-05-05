//
//  DailyBriefRow.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import SwiftUI

struct DailyBriefRow: View {
    var currentBrief: DailyBrief
        
    var coverImageURL: URL? {
        if let coverImageURL = self.currentBrief.imageURL {
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
            VStack {
                HStack(alignment: .top, spacing: 7) {
                    VStack(alignment: .leading) {
                        Text(currentBrief.headline ?? "The world in brief")
                            .font(Font.custom("Georgia", size: 20))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.defaultFontColor)
                        Spacer()
                    }
                    Spacer()
                    if let imageURL = self.coverImageURL {
                        AsyncImage(url: imageURL) { phase in
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
                }
                Divider()
                HStack {
                    Text("The Economist Espresso")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.bottom, 10)
            }
            .padding([.leading, .trailing, .top])
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
        .overlay(content: {
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.boundColor, lineWidth: 1)
        })
        .padding(.bottom, 3.5)
        .padding(.top, 3.5)
        .padding([.leading, .trailing], 7)
    }
}

struct DailyBriefRow_Previews: PreviewProvider {
    static var previews: some View {
        DailyBriefRow(currentBrief: DailyBrief(id: 0, headline: "Peace remains elusive in Sudan", imageURL: "https://cdn.espresso.economist.com/files/public/images/20230506_dap323.jpg", contents: []))
    }
}
