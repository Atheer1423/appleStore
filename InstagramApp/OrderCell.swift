//
//  OrderCell.swift
//  InstagramApp
//
//  Created by Atheer Alha on 23/06/1443 AH.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var ProductPrice: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
