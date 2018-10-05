//
//  Participant.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation

class Match: NSObject, Decodable {
  
  var heroId: Int?
  var playerSlot: Int?
  var radiantWin: Bool?
  var kills: Int?
  var deaths: Int?
  
  enum Result: String {
    case win = "Win"
    case loss = "Loss"
  }
  
  func result() -> String? {
    guard playerSlot != nil, radiantWin != nil else { return nil}
    switch playerSlot! {
    // player is part of the Radiant team
    case 0...127:
      return radiantWin! == true ? Result.win.rawValue : Result.loss.rawValue
    // player is part of the Dire team
    case 128...255:
      return radiantWin! == true ? Result.loss.rawValue : Result.win.rawValue
    default:
      return nil
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case heroId = "hero_id"
    case playerSlot = "player_slot"
    case radiantWin = "radiant_win"
    case kills
    case deaths
  }
  
  init(heroId: Int, playerSlot: Int, radiantWin: Bool, kills: Int, deaths: Int) {
    self.heroId = heroId
    self.radiantWin = radiantWin
    self.kills = kills
    self.deaths = deaths
  }
}
