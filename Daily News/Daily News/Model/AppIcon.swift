//
//  AppIcon.swift
//  Daily News
//
//  Created by Huang Runhua on 5/8/23.
//

import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case applenews = "AppIcon-news"
    case economist = "AppIcon-economist"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .primary:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .primary:
            return "Default"
        case .applenews:
            return "News"
        case .economist:
            return "Economist"
        }
    }

    var preview: UIImage {
        UIImage(named: rawValue + "-Preview") ?? UIImage()
    }
}
