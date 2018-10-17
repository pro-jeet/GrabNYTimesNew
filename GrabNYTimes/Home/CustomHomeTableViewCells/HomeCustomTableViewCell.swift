//
//  HomeCustomTableViewCell.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 12/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import UIKit

class HomeCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.borderColor = UIColor(displayP3Red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1).cgColor
        mainView.layer.borderWidth = 1.0
        titleLabel.alpha = 1.0
        
        descriptionImageView.layer.borderWidth = 1
        descriptionImageView.layer.masksToBounds = false
        descriptionImageView.layer.borderColor = UIColor.black.cgColor
        descriptionImageView.layer.cornerRadius = descriptionImageView.frame.height/2
        descriptionImageView.clipsToBounds = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
