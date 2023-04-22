//
//  DictionarySearchViewController.swift
//  OpenDictionary
//
//  Created by Huang Runhua on 4/22/23.
//

import SwiftUI
import UIKit

struct DictionarySearchViewController: UIViewControllerRepresentable {
    
    var word: String

    func makeUIViewController(context: Context) -> UIReferenceLibraryViewController {
        let dictionarySearchViewController = UIReferenceLibraryViewController(term: word)

        return dictionarySearchViewController
    }

    func updateUIViewController(_ pageViewController: UIReferenceLibraryViewController, context: Context) {

    }
}
