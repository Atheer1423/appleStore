//
//  BascketVC.swift
//  InstagramApp
//
//  Created by administrator on 22/01/2022.
//

import UIKit
import Kingfisher
class FavouritesVC : UIViewController {
    var favProducts : [product] = []
  
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//get all fav for person email
        
        getFavourites()
    }
    
    func getFavourites(){
        
        DatabaseManager.shared.getFavouritesProducts("Atheersalalha@hotmail.com"){ [weak self]results in
            switch results {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.favProducts = products
                    self?.tableViewOutlet.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
  

}

extension FavouritesVC  : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavouritesCell
        let oneProduct = favProducts[indexPath.row]
        cell.imageProduct.kf.setImage(with: URL(string:oneProduct.image))
        cell.nameProduct.text = oneProduct.name
        cell.priceProduct.text = oneProduct.price
        cell.colorProduct.text = oneProduct.color
        
        return cell
    }
    
    
    
}
