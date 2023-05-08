//
//  SettingView.swift
//  Daily News
//
//  Created by Huang Runhua on 5/8/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel: ChangeAppIconViewModel
    @Environment(\.dismiss) var dismiss
    
    private let threeColumnGrid: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List {
                    Section {
                        GeometryReader { proxy in
                            LazyVGrid(columns: threeColumnGrid, spacing: 2) {
                                ForEach(AppIcon.allCases) { appIcon in
                                    VStack {
                                        Image(uiImage: appIcon.preview)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: proxy.size.width/5)
                                            .cornerRadius(12)
                                            .shadow(radius: 1)
                                        CheckboxView(isSelected: viewModel.selectedAppIcon == appIcon, iconDescription: appIcon.description)
                                    }
                                    .padding()
                                    .frame(width: proxy.size.width/3)
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.updateAppIcon(to: appIcon)
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("APP ICON")
                    } footer: {
                        Text("Choose the style for how icon shows.")
                    }
                }
                .environment(\.defaultMinListRowHeight, geo.size.width/3)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(ChangeAppIconViewModel())
    }
}

struct CheckboxView: View {
    let isSelected: Bool
    let iconDescription: String

    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 24)
            .foregroundColor(.accentColor)
            .opacity(isSelected ? 1: 0)
            .overlay {
                Text(iconDescription)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white: .defaultFontColor)
            }
        
        
    }
}
