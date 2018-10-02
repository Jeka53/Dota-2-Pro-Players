//
//  Player.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class Player: NSObject, Decodable {

  var accountId: Int
  var avatar: URL?
  var name: String?
  var countryCode: String?
  var team: String?
  var role: Int?
  
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
  }
  
  init(accountId: Int, avatar: URL, name: String, countryCode: String, team: String, role: Int) {
    self.accountId = accountId
    self.avatar = avatar
    self.name = name
    self.countryCode = countryCode
    self.team = team
    self.role = role
  }
}
