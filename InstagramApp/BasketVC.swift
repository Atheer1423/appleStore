//
//  BasketVC.swift
//  InstagramApp
//
//  Created by administrator on 23/01/2022.
//

import UIKit
import Kingfisher
class BasketVC: UIViewController {
    var basProduct : [product] = []
  
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getbasketProduct()
    }
    
    func getbasketProduct(){
        DatabaseManager.shared.getBasketProducts("Atheersalalha@hotmail.com") { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async{
                  
                    self?.basProduct = products
                    self?.tableViewOutlet.reloadData()
                }
            case .failure(let error):
                print(error)
            }
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
      return cell
        
    }
    

    
    
}
