//
//  UpcomingHikesTableViewCell.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 4/1/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit

class UpcomingHikesTableViewCell: UITableViewCell {

    //MARK: Attributes
    
    @IBOutlet weak var TrailNameButton: UIButton!
    
    @IBOutlet weak var upcomingHikeDateLabel: UILabel!
    
    @IBOutlet weak var upcomingHikeLocationLabel: UILabel!
    
    @IBOutlet weak var upcomingHikeDistanceLabel: UILabel!
    
    @IBOutlet weak var upcomingHikeElevationGainLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
