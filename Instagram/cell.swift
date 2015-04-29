//
//  cell.swift
//  Instagram
//
//  Created by Richard Tyran on 4/28/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class cell: UITableViewCell {

    @IBOutlet var postedImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
