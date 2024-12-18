//
//  OverviewTableViewCell.swift
//  ShareWise Ease
//
//  Created by apple on 18/10/2024.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var salesTypeLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var Imagees: UIImageView!

    @IBOutlet weak var amountOFProductLabel: UILabel!
    @IBOutlet weak var saleMenNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 12
        
        // Set up shadow properties
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4.0
        contentView.layer.masksToBounds = false
        
        // Set background opacity
        contentView.alpha = 1.5 // Adjust opacity as needed
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
