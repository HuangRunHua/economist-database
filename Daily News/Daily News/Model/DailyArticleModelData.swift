//
//  DailyArticleModelData.swift
//  Daily News
//
//  Created by Huang Runhua on 11/30/22.
//

import Foundation
import Combine

final class DailyArticleModelData: ObservableObject, Decodable {

    @Published var magazine: Magazine?
    @Published var article: Article?

    @Published var latestMagazineURL: [LatestMagazineURL] = []
    @Published var latestMagazine: [Magazine] = []
    @Published var latestArticles: [Article] = []
    
    enum CodingKeys: CodingKey {
        case latestMagazineURL
    }
    
    required init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        latestMagazineURL = try value.decode([LatestMagazineURL].self, forKey: .latestMagazineURL)
    }
    
    init() {}
    
    func fetchLatestEposideMagazineURL(urlString: String) {
        guard let databaseURL = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: databaseURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print("99800000.")
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.latestMagazineURL = self._parseLatestMagazineJsonData(data: data)
                }
            }
        }
        task.resume()
    }
    
    private func _parseLatestMagazineJsonData(data: Data) -> [LatestMagazineURL] {
        let decoder = JSONDecoder()
        do {
            let latestMagazineURL = try decoder.decode([LatestMagazineURL].self, from: data)
            self.latestMagazineURL = latestMagazineURL
        } catch {
            print("39999999.")
            print(error)
        }
        return latestMagazineURL
    }
    
    func fetchLatestArticles() {
        self.latestArticles = []
        if let latestMagazine = self.latestMagazine.first {
            print("==========****************")
            for article in latestMagazine.articles.sorted(by: { $0.id < $1.id}) {
                _fetchLatestArticle(urlString: article.articleURL)
            }
        }
    }
    
    private func _fetchLatestArticle(urlString: String) {
        guard let articleURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: articleURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print("1.")
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let currentArticle = self._parseArticleJsonData(data: data) {
                        self.latestArticles.append(currentArticle)
                    } else {
                        print("No current article found")
                    }
                }
            }
        }
        task.resume()
    }
    
    private func _parseArticleJsonData(data: Data) -> Article? {
        let decoder = JSONDecoder()
        do {
            let article = try decoder.decode(Article.self, from: data)
            self.article = article
        } catch {
            print("5999999999.")
            print(error)
        }
        return article
    }
    
    func fetchLatestMagazine() {
        self.latestMagazine = []
        for magazineURL in self.latestMagazineURL {
            _fetchLatestMagazine(urlString: magazineURL.magazineURL)
        }
        self.latestMagazine = self.latestMagazine
    }
    
    private func _fetchLatestMagazine(urlString: String) {
        guard let magazineURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: magazineURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print("990.")
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let latest = self._parseMagazineJsonData(data: data) {
                        self.latestMagazine.append(latest)
                    } else {
                        print("No current magazine found")
                    }
                }
            }
        }
        task.resume()
    }
    
    private func _parseMagazineJsonData(data: Data) -> Magazine? {
        let decoder = JSONDecoder()
        do {
            let magazine = try decoder.decode(Magazine.self, from: data)
            self.magazine = magazine
        } catch {
            print("4.")
            print(error)
        }
        return magazine
    }
}
