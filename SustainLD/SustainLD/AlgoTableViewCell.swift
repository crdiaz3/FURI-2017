//
//  AlgoTableViewCell.swift
//  SustainLD
//
//  Created by Christopher Diaz on 4/12/17.
//  Copyright © 2017 Christopher Diaz. All rights reserved.
//

import UIKit

class AlgoTableViewCell: UITableViewCell {

    @IBOutlet weak var globe: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
