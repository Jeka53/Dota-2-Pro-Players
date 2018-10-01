//
//  PlayerTableViewCell.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var countryCodeLabel: UILabel!
  @IBOutlet weak var teamLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    avatarImageView.layer.cornerRadius = 8
    avatarImageView.clipsToBounds = true
  }
  
  var player: Player? {
    didSet {
      guard let player = player else { return }
      avatarImageView.kf.setImage(with: player.avatar, placeholder: UIImage(named: "avatarPlaceholder"), options: [.transition(.fade(0.4))])
      nameLabel.text = player.name
      countryCodeLabel.text = flag(from: player.countryCode)
      teamLabel.text = player.team
      roleLabel.text = player.roles[player.role ?? Int.max]
    }
  }
  
  // Create Flag emoji based on Country Code ISO 3166-1
  func flag(from country:String?) -> String? {
    guard country != nil else { return nil }
    let base : UInt32 = 127397
    var flagString = ""
    for unicodeScalar in country!.uppercased().unicodeScalars {
      flagString.unicodeScalars.append(UnicodeScalar(base + unicodeScalar.value)!)
    }
    return flagString
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
