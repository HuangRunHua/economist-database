//
//  MagazineCoverRow.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineCoverRow: View {
    
    var magazine: Magazine
    
//    var coverImageURL: URL? {
//        return URL(string: self.magazine.coverImageURL)
//    }
    
    @State private var coverImageURL: URL? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            AsyncImage(url: self.coverImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                case .empty, .failure:
                    Rectangle()
                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(7)
            .shadow(radius: 7)
            .padding([.top, .bottom])
            HStack {
                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 11)
                    .foregroundColor(Color.cloudColor)
                    .layoutPriority(1)
                Text(self.magazine.date.uppercased())
                    .font(Font.custom("Georgia", size: 11))
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .layoutPriority(0.5)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.defaultFontColor)
                }
                .layoutPriority(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.coverImageURL = URL(string: self.magazine.coverImageURL)
        }
    }
}

struct MagazineCoverRow_Previews: PreviewProvider {
    static var previews: some View {
        MagazineCoverRow(magazine: Magazine(id: "111111-1111-1111-111111111111", coverStory: "cover story", coverImageURL: "https://media.newyorker.com/photos/632de17e882c6ff52b2d3b1f/master/w_380,c_limit/2022_10_03.jpg", coverImageWidth: 555, coverImageHeight: 688, articles: [], date: "Oct 3rh 2022"))
    }
}
