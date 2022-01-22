//
//  FavouritesCell.swift
//  InstagramApp
//
//  Created by administrator on 22/01/2022.
//

import UIKit

class FavouritesCell: UITableViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var colorProduct: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToBascketBtn(_ sender: UIButton) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
