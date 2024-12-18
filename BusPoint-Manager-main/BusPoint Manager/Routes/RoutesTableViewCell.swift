//
//  RoutesTableViewCell.swift
//  BusStand Hub
//
//  Created by Maaz on 27/11/2024.
//

import UIKit

class RoutesTableViewCell: UITableViewCell {

    @IBOutlet weak var DepartedTimingLabel: UILabel!
    @IBOutlet weak var DateOfTheDayLabel: UILabel!
    @IBOutlet weak var fairLabel: UILabel!
    @IBOutlet weak var DetinationLabel: UILabel!
    @IBOutlet weak var StartfromLabel: UILabel!
    @IBOutlet weak var BusNameLabel: UILabel!
    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var SellButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    
    var deleteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyGradientToButtonThree(view: SellButton)

                 contentView.layer.cornerRadius = 18
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
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
           deleteAction?() // Call the delete action when the button is tapped
       }
}
