//
//  DailyBriefModelData.swift
//  Daily News
//
//  Created by Huang Runhua on 5/6/23.
//

import Foundation

final class DailyBriefModelData: ObservableObject {
    @Published var dailyBriefs: [DailyBrief] = []
    
    func startLoadingBrief(urlString: String) {
        self.dailyBriefs.removeAll()
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error = \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Bad response = \(responseCode)")
                }
                return
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.dailyBriefs = BriefParser.fetchJSON(sourcePageString: string)
                }
            }
        }
        task.resume()
    }
}
