//
//  ColorExtensions.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI

extension Color {
    static let defaultFontColor = Color("defaultFontColor")
    static let cloudColor = Color("cloudColor")
    static let hashtagColor = Color("hashtagColor")
    static let cardColor = Color("cardColor")
    static let tabColor = Color("tabColor")
    static let dictionaryTextColor = Color("dictionaryTextColor")
    static let boundingColor = Color("boundingColor")
    static let boundColor = Color("boundColor")
}

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}

extension String {
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
    
    var pureWord: String {
        var startIndex: Index?
        for i in self {
            if i.isLetter {
                startIndex = self.firstIndex(of: i)
                break
            }
        }
        var end: Int = 0
        for i in self.reversed() {
            if i.isLetter {
                break
            }
            end += 1
        }
        
        if let startIndex {
            return String(self[self.index(startIndex, offsetBy: 0)..<self.index(endIndex, offsetBy: -end)])
        } else {
            return ""
        }
        
    }
}

extension View {
    func convertToScrollView<Content: View>(@ViewBuilder content: @escaping ()->Content) ->UIScrollView {
        let scrollView = UIScrollView()
        let hostingController = UIHostingController(rootView: content()).view!
        hostingController.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostingController.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            hostingController.widthAnchor.constraint(equalToConstant: screenBounds().width)
        ]
        
        scrollView.addSubview(hostingController)
        scrollView.addConstraints(constraints)
        scrollView.layoutIfNeeded()
        return scrollView
    }
    
    func exportPDF<Content: View>(@ViewBuilder content: @escaping ()->Content, completion: @escaping (Bool, URL?)->()) {
        let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("ARTICLE\(UUID().uuidString).pdf")
        let pdfView = convertToScrollView {
            content()
        }
        pdfView.tag = 1009
        
        let size = pdfView.contentSize
        pdfView.frame = CGRect(x: 0, y: getSafeArea().top, width: size.width, height: size.height)
        
        getRootController().view.insertSubview(pdfView, at: 0)
        
        let render = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        do {
            try render.writePDF(to: outputFileURL, withActions: { context in
                context.beginPage()
                pdfView.layer.render(in: context.cgContext)
            })
            
            completion(true, outputFileURL)
        } catch {
            completion(false, nil)
            print(error.localizedDescription)
        }
        
        getRootController().view.subviews.forEach { view in
            if view.tag == 1009 {
                view.removeFromSuperview()
            }
        }
    }
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
