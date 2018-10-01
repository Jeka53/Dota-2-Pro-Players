//
//  Player.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class Player: NSObject, Decodable {
  
  let roles: [Int: String] = [
    0: "Safe Lane",
    1: "Mid Lane",
    2: "Offlane",
    3: "Jungle"
  ]
  
  var avatar: URL?
  var name: String?
  var countryCode: String?
  var team: String?
  var role: Int?
  
  enum CodingKeys: String, CodingKey {
    case avatar = "avatarfull"
    case name
    case countryCode = "loccountrycode"
    case team = "team_name"
    case role = "fantasy_role"
  }
  
  init(avatar: URL, name: String, countryCode: String, team: String, role: Int) {
    self.avatar = avatar
    self.name = name
    self.countryCode = countryCode
    self.team = team
    self.role = role
  }
}
