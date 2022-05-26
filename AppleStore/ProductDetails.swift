//
//  ProductDetails.swift
//  InstagramApp
//
//  Created by administrator on 22/01/2022.
//

import UIKit
import Kingfisher
class ProductDetails: UIViewController {

    @IBOutlet weak var FavBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var pruductPrice: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
   
    var product : product?
    override func viewDidLoad() {
        super.viewDidLoad()
      
      setUp()
    }
    
   func setUp(){
       print(UserDefaults.standard.value(forKey: "email"))
       if let Product = product {
           containerView.layer.cornerRadius = containerView.frame.width/15
           containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
           stackView.layer.cornerRadius = stackView.frame.width/15
           stackView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
           btn.layer.cornerRadius = btn.frame.width/17
           productImage.layer.masksToBounds = true
         
           productImage.kf.setImage(with:URL(string: Product.image))
//           if let url = URL(string: "\(Product.image).png"){
//          if let data = try? Data(contentsOf : url){
//              if let image = UIImage(data:data){
//                  productImage.image = image
//
//              }
//           }
//           }
           productName.text = Product.name
           productColor.text = Product.color
           pruductPrice.text = Product.price
           
       }
    }
    @IBAction func backBtn(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addToBasketBtn(_ sender: UIButton) {
        DatabaseManager.shared.addProductToBasket(product!, "Atheersalalha@hotmail.com") { success in
            
            if success {
                
            } else{
                
            }
            
            
        }
        
    }
    @IBAction func addToFavourites(_ sender: UIButton) {
        // get email from sign in and signup -safe email before add to db-userdef
        
        // get product obj sent 2 to database add to fav
        FavBtn.tintColor = .red
        DatabaseManager.shared.addToFavourites(product!, "Atheersalalha@hotmail.com") { success in
            
            if success {
                
            } else{
                
            }
            
            
        }
    }
    /*
    // MARK: - Navigation
    
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
