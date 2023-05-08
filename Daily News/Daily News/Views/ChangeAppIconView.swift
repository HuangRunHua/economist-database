//
//  ChangeAppIconView.swift
//  Daily News
//
//  Created by Huang Runhua on 5/8/23.
//

import SwiftUI

struct ChangeAppIconView: View {
    @EnvironmentObject var viewModel: ChangeAppIconViewModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 11) {
                    ForEach(AppIcon.allCases) { appIcon in
                        HStack(spacing: 16) {
                            Image(uiImage: appIcon.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                            Text(appIcon.description)
                            Spacer()
                            CheckboxView(isSelected: viewModel.selectedAppIcon == appIcon)
                        }
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                viewModel.updateAppIcon(to: appIcon)
                            }
                        }
                    }
                }.padding(.horizontal)
                    .padding(.vertical, 40)
            }
        }
//        .background(Color(UIColor.pageBackground).ignoresSafeArea())
    }
}

struct ChangeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAppIconView()
            .environmentObject(ChangeAppIconViewModel())
    }
}

struct CheckboxView: View {
    let isSelected: Bool

    private var image: String {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        return imageName
    }

    var body: some View {
        Image(systemName: image)
    }
}
