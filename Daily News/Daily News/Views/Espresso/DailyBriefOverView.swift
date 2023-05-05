//
//  DailyBriefOverView.swift
//  the-world-in-brief
//
//  Created by Huang Runhua on 5/5/23.
//

import SwiftUI

struct DailyBriefOverView: View {
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
        ZStack(alignment: .bottom) {
            if let imageURL = self.coverImageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: self.width, height: self.width)
                            .cornerRadius(7)
                            .shadow(radius: 5)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: self.width, height: self.width)
                            .foregroundColor(.gray)
                            .cornerRadius(7)
                            .shadow(radius: 5)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack {
                HStack {
                    Text("The world in brief")
                        .font(Font.custom("Georgia", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.defaultFontColor)
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                
                HStack {
                    Text("Catch up quickly on the global stories that matter")
                        .font(Font.custom("Georgia", size: 17))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.defaultFontColor)
                    Spacer()
                }
                .padding(.top, -7)
                .padding([.leading, .trailing])
                
                Divider()
                
                HStack {
                    Text("The Economist Espresso")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.leading)
                .padding([.bottom, .trailing], 10)
            }
            .background(Color.cardColor)
        }
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.boundColor, lineWidth: 1)
        )
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
}

struct DailyBriefOverView_Previews: PreviewProvider {
    static var previews: some View {
        DailyBriefOverView(dailyBriefImagePath: "https://cdn.espresso.economist.com/files/public/images/20230506_dap334.jpg")
    }
}
