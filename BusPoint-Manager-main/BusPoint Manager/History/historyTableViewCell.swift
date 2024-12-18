//
//  historyTableViewCell.swift
//  BusStand Hub
//
//  Created by Maaz on 27/11/2024.
//

import UIKit

class historyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DiscountLabel: UILabel!
    @IBOutlet weak var PhoneNoLabel: UILabel!

    @IBOutlet weak var DepartedTimingLabel: UILabel!
    @IBOutlet weak var DateOfTheDayLabel: UILabel!
    @IBOutlet weak var fairLabel: UILabel!
    @IBOutlet weak var DetinationLabel: UILabel!
    @IBOutlet weak var StartfromLabel: UILabel!
    @IBOutlet weak var BusNameLabel: UILabel!
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var cView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 18
       // Set up shadow properties
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cView.layer.shadowOpacity = 0.3
        cView.layer.shadowRadius = 4.0
        cView.layer.masksToBounds = false
       // Set background opacity
        cView.alpha = 1.5 // Adjust opacity as needed // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
