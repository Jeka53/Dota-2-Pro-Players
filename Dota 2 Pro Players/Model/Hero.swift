//
//  Hero.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/4/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import Foundation

class Hero: NSObject, Decodable {
  
  var id: Int?
  var localizedName: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case localizedName = "localized_name"
  }
  
  init(id: Int, localizedName: String) {
    self.id = id
    self.localizedName = localizedName
  }
}
