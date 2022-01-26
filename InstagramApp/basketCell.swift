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
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func stepperPressed(_ sender: UIStepper) {
        let oldprice = productPrice.text?.replacingOccurrences(of: "$", with: " ")
        let Oldprice = ( oldprice! as NSString).integerValue
        let OldQ = (productQuantity.text! as NSString ).integerValue
        productQuantity.text = "\(Int(stepperOutlet.value))"
        if let Price = price?.replacingOccurrences(of: "$", with: " "){
       var sum = true
          
        let PriceInt = ( Price as NSString).integerValue
          
        if let q =  productQuantity.text {
            print("quan")
           let IntQ = ( q as NSString).integerValue
            if IntQ > OldQ {
                sum = true
                let totalPrice = IntQ * PriceInt
                
//                print( "int q \(IntQ)")
//                print("totalproduct one \(totalPrice)")
                let res = Oldprice + 400
                productPrice.text = "\(res) $"
                let newPrice = totalPrice - Oldprice
                delegate?.sendQuantity(price: res,sum: sum)
                DatabaseManager.shared.editQuantityAndPrice(id!,"Atheersalalha@hotmail.com",q , String(res)) { success in

                }
            }else{
                sum = false
                let totalPrice = IntQ * PriceInt
                print( "int q \(IntQ)")
                print("totalproduct one \(totalPrice)")
                let res = Oldprice - 400
                productPrice.text = "\(res) $"
                let newPrice = totalPrice - Oldprice
                delegate?.sendQuantity(price: res, sum: sum )
            DatabaseManager.shared.editQuantityAndPrice(id!,"Atheersalalha@hotmail.com",q , String(res)) { success in

            }
        }
        }
      
    }
}
}
