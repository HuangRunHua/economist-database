//
//  DailyBriefArticleView_iPad.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI
import NukeUI

struct DailyBriefOverView_iPad: View {
    
    var dailyBriefImagePath: String?
        
    var coverImageURL: URL? {
        if let coverImageURL = self.dailyBriefImagePath {
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
                    VStack(alignment: .leading, spacing: 7) {
                        Text("The world in brief")
                            .font(Font.custom("Georgia", size: 20))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.defaultFontColor)
                            .layoutPriority(1)
                        
                        Text("Catch up quickly on the global stories that matter")
                            .font(Font.custom("Georgia", size: 17))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.defaultFontColor)
                            .layoutPriority(0.5)
                        Spacer()
                    }
                    Spacer()
                    if let imageURL = self.coverImageURL {
                        LazyImage(url: imageURL, content: { phase in
                            switch phase.result {
                            case .success:
                                phase.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(7)
                            case .failure:
                                Rectangle()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.secondary)
                                    .cornerRadius(7)
                            case .none, .some:
                                Rectangle()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.secondary)
                                    .cornerRadius(7)
                            }
                        })
                        .priority(.low)
                        .layoutPriority(1)
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

struct DailyBriefOverView_iPad_Previews: PreviewProvider {
    static var previews: some View {
        DailyBriefOverView_iPad(dailyBriefImagePath: "https://cdn.espresso.economist.com/files/public/images/20230506_dap334.jpg")
    }
}
