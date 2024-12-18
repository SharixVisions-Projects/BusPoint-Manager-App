//
//  ViewSalesTableViewCell.swift
//  ShareWise Ease
//
//  Created by Maaz on 17/10/2024.
//

import UIKit

class ViewSalesTableViewCell: UITableViewCell {

    @IBOutlet weak var busnameLabel: UILabel!
    @IBOutlet weak var passengerNameLbl: UILabel!
    @IBOutlet weak var passengerNoLbl: UILabel!
    @IBOutlet weak var passengerAddressLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departedtimeLbl: UILabel!
    @IBOutlet weak var departedplaceLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!

    
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
