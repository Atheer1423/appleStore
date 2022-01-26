//
//  FavouritesCell.swift
//  InstagramApp
//
//  Created by administrator on 22/01/2022.
//

import UIKit

class FavouritesCell: UITableViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    var product : product?
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var colorProduct: UILabel!
    @IBOutlet weak var nameProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToBascketBtn(_ sender: UIButton) {
       
            DatabaseManager.shared.addProductToBasket(product!, "Atheersalalha@hotmail.com") { success in
                
                if success {
                    
                } else{
                    
                }
                
                
            }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
