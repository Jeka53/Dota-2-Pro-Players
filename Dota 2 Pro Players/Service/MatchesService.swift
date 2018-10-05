//
//  PlayedWithService.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation

class MatchesService: NSObject {
  
  static let service = MatchesService()
  
  // URL paths
  let matchesPath = "/players/"
  let afterParameterPath = "/matches"
  let heroesPath = "/heroes"
  
  @objc dynamic private(set) var heroesDic: [Int:String] = [:]
  @objc dynamic private(set) var matches: [Match] = []
  
  private(set) var isForceRefresh = false
  
  private var heroes: [Hero] = [] {
    didSet {
      var heroesCopy: [Int: String] = [:]
      heroes.forEach {
        guard $0.id != nil, $0.localizedName != nil else { return }
        heroesCopy[$0.id!] = $0.localizedName!
      }
      // refreshes table view onse when all data is parsed
      heroesDic = heroesCopy
    }
  }
  
  // MARK: - Fetch matches data
  private func fetchData(accountId: Int, offset: Int, limit: Int, completion: @escaping (Data) -> ()) {
    let session = URLSession(configuration: .default)
    let limitQueryParameter = "?limit=\(limit)"
    let offsetQueryParameter = "&offset=\(offset)"
    let url = URL(string: baseURL + matchesPath + String(accountId) + afterParameterPath + limitQueryParameter + offsetQueryParameter)!
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
  
  func fetchMatches(accountId: Int, offset: Int, limit: Int) {
    MatchesService.service.fetchData(accountId: accountId, offset: offset, limit: limit) { (data) in
      do {
        let matches = try JSONDecoder().decode([Match].self, from: data)
        self.isForceRefresh = false
          self.matches.append(contentsOf: matches)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  // MARK: - Fetch hero data
  private func fetchHeroes(completion: @escaping (Data) -> ()) {
    let session = URLSession(configuration: .default)
    let url = URL(string: baseURL + heroesPath)!
    let task = session.dataTask(with: url) { (data, _, error) in
      guard error == nil else {
        print(error.debugDescription)
        return
      }
      if let data = data {
        completion(data)
      }
    }
    task.resume()
  }
  
  
  
  func fetchHeroes() {
    MatchesService.service.fetchHeroes { data in
      do {
        let heroes = try JSONDecoder().decode([Hero].self, from: data)
        self.heroes = heroes
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func changeRefreshStatus() {
    isForceRefresh = !isForceRefresh
  }
  
  // MARK: - Clean mathes data
  func eraseMatches() {
    self.matches = []
  }
  
  // MARK: - Clean all data
  func eraseData() {
    self.matches = []
    self.heroes = []
  }
}
