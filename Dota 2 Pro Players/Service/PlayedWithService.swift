//
//  PlayedWithService.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation
import Kingfisher

class PlayedWithService: NSObject {
  
  static let service = PlayedWithService()
  
  let path = "/players/"
  let afterParameterPath = "/pros"
  
  @objc dynamic private(set) var playedWith: [Participant] = []
  
  private func fetchData(accountId: Int, completion: @escaping (Data) -> ()) {
    let session = URLSession(configuration: .default)
    let url = URL(string: baseURL + path + String(accountId) + afterParameterPath)!
    let task = session.dataTask(with: url) { data, response, error in
      guard error == nil else {
        NSLog(error.debugDescription, [])
        return
      }
      if let data = data {
        completion(data)
      } else {
        print(error.debugDescription)
      }
    }
    task.resume()
  }
  
  func fetchPlayedWithPlayers(accountId: Int) {
    PlayedWithService.service.fetchData(accountId: accountId) { (data) in
      do {
        let participants = try JSONDecoder().decode([Participant].self, from: data)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearDiskCache()
        self.playedWith = participants
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func eraseData() {
    self.playedWith = []
  }
}
