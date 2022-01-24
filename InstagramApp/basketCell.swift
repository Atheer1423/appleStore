//
//  basketCell.swift
//  InstagramApp
//
//  Created by administrator on 23/01/2022.
//

import UIKit



class basketCell: UITableViewCell {
    var id: String?
    var delegate: SendQuantityProtocol?
    var price : String?
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let quantity = productQuantity.text {
            stepperOutlet.value = Double(Int(String(quantity)) ?? 0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func stepperPressed(_ sender: UIStepper) {
      
        productQuantity.text = "\(Int(stepperOutlet.value))"
        if let Price = price?.replacingOccurrences(of: "$", with: " "){
        print(Price)
          
        let PriceInt = ( Price as NSString).integerValue
            print(PriceInt)
        if let q =  productQuantity.text {
    print(q)
            let totalPrice =  ( q as NSString).integerValue * PriceInt
            print( ( q as NSString).integerValue)
            print("totalproduct \(totalPrice)")
            productPrice.text = "\(totalPrice) $"
            delegate?.sendQuantity(price: totalPrice)
            DatabaseManager.shared.editQuantity(id!,"Atheersalalha@hotmail.com",q ) { success in
                
            }
        }
        }
        // add quant
    }
}
