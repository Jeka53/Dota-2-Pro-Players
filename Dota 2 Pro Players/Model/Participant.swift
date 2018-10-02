//
//  Participant.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation

class Participant: NSObject, Decodable {
  
  var accountId: Int
  var avatar: URL?
  var name: String?
  var countryCode: String?
  var team: String?
  var role: Int?
  var totalGames: Int?
  var withWin: Int?
  var withTotal: Int?
  var againstWin: Int?
  var againstTotal: Int?
  
  let roles: [Int: String] = [
    0: "Safe Lane",
    1: "Mid Lane",
    2: "Offlane",
    3: "Jungle"
  ]
  
  enum CodingKeys: String, CodingKey {
    case accountId = "account_id"
    case avatar = "avatarfull"
    case name
    case countryCode = "loccountrycode"
    case team = "team_name"
    case role = "fantasy_role"
    case totalGames = "games"
    case withWin = "with_win"
    case withTotal = "with_games"
    case againstWin = "against_win"
    case againstTotal = "against_games"
  }
  
  init(accountId: Int,
       avatar: URL,
       name: String,
       countryCode: String,
       team: String,
       role: Int,
       totalGames: Int,
       withWin: Int,
       withTotal: Int,
       againstWin: Int,
       againstTotal: Int) {
    self.accountId = accountId
    self.avatar = avatar
    self.name = name
    self.countryCode = countryCode
    self.team = team
    self.role = role
    self.totalGames = totalGames
    self.withWin = withWin
    self.withTotal = withTotal
    self.againstWin = againstWin
    self.againstTotal = againstTotal
  }
}
