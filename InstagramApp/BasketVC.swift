//
//  BasketVC.swift
//  InstagramApp
//
//  Created by administrator on 23/01/2022.
//

import UIKit
import Kingfisher

protocol SendQuantityProtocol {
    func sendQuantity(price:Int, sum:Bool)
}

class BasketVC: UIViewController , SendQuantityProtocol {
  
    var basProduct : [product] = []
   
    @IBOutlet weak var totalOutlet: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.layer.cornerRadius = btn.frame.width/17
        getbasketProduct()
     
    }
    func getTotal (){
      var total = 0
        for product in basProduct {
            let price = product.price.replacingOccurrences(of: "$", with: " ")
            total =  total + (price as NSString).integerValue
        }
        totalOutlet.text = "\(total) $"
    }
    func getbasketProduct(){
        DatabaseManager.shared.getBasketProducts("Atheersalalha@hotmail.com") { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async{
                  
                    self?.basProduct = products
                    self?.tableViewOutlet.reloadData()
                    self?.getTotal()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendQuantity(price: Int, sum :Bool) {
        if let CurrentTotal = totalOutlet.text?.replacingOccurrences(of: "$", with: " "){
        let currentTotal = ( CurrentTotal as NSString).integerValue
            var newTotal = 0
        if sum {
         newTotal = currentTotal + price
        }else{
             newTotal = currentTotal - price
        }
            totalOutlet.text = "\(newTotal)   $"
            
    }
}
    
    @IBAction func CheckOutBtnPressed(_ sender: UIButton) {
        if !basProduct.isEmpty {
        let orderVC = storyboard?.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
        orderVC.orderItems = basProduct
        orderVC.total = totalOutlet.text
        orderVC.modalPresentationStyle = .fullScreen
        present(orderVC, animated: true, completion: nil)
        }
    }
    
}

extension BasketVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basCell", for: indexPath) as! basketCell

        cell.productName.text = basProduct[indexPath.row].name
        cell.productImage.kf.setImage(with: URL(string:(basProduct[indexPath.row].image)))
        cell.productPrice.text = basProduct[indexPath.row].price
        cell.productQuantity.text = basProduct[indexPath.row].quantity!
        cell.id = basProduct[indexPath.row].id
        cell.price = basProduct[indexPath.row].price
        cell.delegate = self
      return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id = basProduct[indexPath.row].id
        basProduct.remove(at: indexPath.row)
        
     
        DatabaseManager.shared.deleteProduct(id:id, "basket") { success in

        }
    }
    
    

    
    
}
