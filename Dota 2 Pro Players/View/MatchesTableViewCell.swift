//
//  PlayedWithTableViewCell.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {
  
  @IBOutlet weak var heroNameLabel: UILabel!
  @IBOutlet weak var matchResultLabel: UILabel!
  @IBOutlet weak var killsLabel: UILabel!
  @IBOutlet weak var deathsLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  var match: Match? {
    didSet {
      guard let match = match else { return }
      heroNameLabel.text = MatchesService.service.heroesDic[match.heroId!]
      matchResultLabel.text = match.result()
      killsLabel.text = String(match.kills!)
      deathsLabel.text = String(match.deaths!)
    }
  }


  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
