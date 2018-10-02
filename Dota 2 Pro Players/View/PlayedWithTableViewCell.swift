//
//  PlayedWithTableViewCell.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 10/2/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class PlayedWithTableViewCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var countryCodeLabel: UILabel!
  @IBOutlet weak var teamLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!
  @IBOutlet weak var totalGamesLabel: UILabel!
  @IBOutlet weak var withWinLabel: UILabel!
  @IBOutlet weak var withLossLabel: UILabel!
  @IBOutlet weak var againstWinLabel: UILabel!
  @IBOutlet weak var againstLossLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    
    avatarImageView.layer.cornerRadius = 8
    avatarImageView.clipsToBounds = true
  }
  
  var participant: Participant? {
    didSet {
      guard let participant = participant else { return }
      avatarImageView.kf.setImage(with: participant.avatar, placeholder: UIImage(named: "avatarPlaceholder"), options: [.transition(.fade(0.4))])
      nameLabel.text = participant.name
      countryCodeLabel.text = flag(from: participant.countryCode)
      teamLabel.text = participant.team
      roleLabel.text = participant.roles[participant.role ?? Int.max]
      totalGamesLabel.text = String(participant.totalGames!)
      withWinLabel.text = String(participant.withWin!)
      withLossLabel.text = String(participant.withTotal! - participant.withWin!)
      againstWinLabel.text = String(participant.againstWin!)
      againstLossLabel.text = String(participant.againstTotal! - participant.againstWin!)
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
