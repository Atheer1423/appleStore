//
//  SearchCell.swift
//  InstagramApp
//
//  Created by Atheer Alha on 25/06/1443 AH.
//

import UIKit

class SearchCell: UITableViewCell {

    
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var Productimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
