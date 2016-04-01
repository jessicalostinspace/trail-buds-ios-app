//
//  HikesAttendedTableViewCell.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 4/1/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit

class HikesAttendedTableViewCell: UITableViewCell {
    
    //MARK: Attributes
    
    @IBOutlet weak var hikesAttendedTrailNameButton: UIButton!

    @IBOutlet weak var hikesAttendedDateLabel: UILabel!
    
    @IBOutlet weak var hikesAttendedLocationLabel: UILabel!
    
    @IBOutlet weak var hikesAttendedDistanceLabel: UILabel!
    
    @IBOutlet weak var hikesAttendedElevationGainLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
