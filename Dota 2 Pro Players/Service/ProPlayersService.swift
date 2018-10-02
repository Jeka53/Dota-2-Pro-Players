//
//  ProPlayersService.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation
import Kingfisher

class ProPlayersService: NSObject {
  
  static let service = ProPlayersService()
  
  let path = "/proPlayers"
  
  @objc dynamic private(set) var players: [Player] = []
  
  private func fetchData(completion: @escaping (Data) -> ()) {
    let session = URLSession(configuration: .default)
    let url = URL(string: baseURL + path)!
    let task = session.dataTask(with: url) { data, responce, error in
      guard error == nil else {
        NSLog(error.debugDescription, [])
        return
      }
      if let data = data {
        completion(data)
      } else {
        print(error.debugDescription)
        NSLog(error.debugDescription, [])
      }
    }
    task.resume()
  }
  
  func fetchProPlayers() {
    ProPlayersService.service.fetchData { data in
      do {
       let proPlayers = try JSONDecoder().decode([Player].self, from: data)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearDiskCache()
        self.players = proPlayers
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  
}
