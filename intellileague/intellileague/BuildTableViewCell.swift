//
//  BuildTableViewCell.swift
//  intellileague
//
//  Created by Shawn Cramp on 2016-03-31.
//  Copyright © 2016 MIT iPhone. All rights reserved.
//

import UIKit

class BuildTableViewCell: UITableViewCell {

    @IBOutlet weak var buildImage: UIImageView!
    @IBOutlet weak var buildName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
