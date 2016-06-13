//
//  AttendeesCollectionViewCell.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 6/13/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit

class AttendeesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 0.0
    }
    
}
