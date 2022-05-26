//
//  OrderVC.swift
//  InstagramApp
//
//  Created by Atheer Alha on 23/06/1443 AH.
//

import UIKit
import Kingfisher
class OrderVC: UIViewController {
    var orderItems : [product]?
    var total : String?
  
    @IBOutlet weak var ContinueBtn: UIButton!
    @IBOutlet weak var totalOutlet: UILabel!
    @IBOutlet weak var OrdertableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ContinueBtn.layer.cornerRadius = ContinueBtn.frame.width/17
        if let Total =  total {
            totalOutlet.text = Total
        }
        
      
    }
    
    @IBAction func ContinueBtnPressed(_ sender: UIButton) {
        let backToHome = storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
        backToHome?.modalPresentationStyle = .fullScreen
        present(backToHome!, animated: true, completion: nil)
    }
}

extension OrderVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderCell
        if let OrederItems = orderItems {
        cell.ProductName.text = OrederItems[indexPath.row].name
        cell.ProductPrice.text = OrederItems[indexPath.row].price
        cell.ProductImage.kf.setImage(with: URL(string: OrederItems[indexPath.row].image))
        cell.productQuantity.text = OrederItems[indexPath.row].quantity
    }
        return cell
}

}
