//
//  ActivityIndicatorCell.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class ActivityIndicatorCell: UITableViewCell {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
