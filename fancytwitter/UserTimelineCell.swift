//
//  UserTimelineCellViewTableViewCell.swift
//  fancytwitter
//
//  Created by Estella Lai on 11/5/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit

class UserTimelineCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
