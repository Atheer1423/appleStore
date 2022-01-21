//
//  ViewController.swift
//  InstagramApp
//
//  Created by administrator on 21/01/2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController {
    var products :[product] = []
   
    @IBOutlet weak var collectionOutlet: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func TabletsPressed(_ sender: UIButton) {
        products = []
        collectionOutlet.reloadData()
        DatabaseManager.shared.getProducts(type: "Tablets") { [weak self] result in
            switch result{
            case .success(let Products):
                DispatchQueue.main.async{
                self?.products = Products
                self?.collectionOutlet.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    @IBAction func PhonePressed(_ sender: UIButton) {
        products = []
        collectionOutlet.reloadData()
        DatabaseManager.shared.getProducts(type: "Phones") { [weak self] result in
            switch result{
            case .success(let Products):
                DispatchQueue.main.async{
                self?.products = Products
                self?.collectionOutlet.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func WearablePressed(_ sender: UIButton) {
        products = []
        collectionOutlet.reloadData()
        DatabaseManager.shared.getProducts(type: "Wearable") { [weak self] result in
            switch result{
            case .success(let Products):
                DispatchQueue.main.async{
                self?.products = Products
                self?.collectionOutlet.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func LabtopPressed(_ sender: UIButton) {
        products = []
        collectionOutlet.reloadData()
        DatabaseManager.shared.getProducts(type: "Labtop") { [weak self] result in
            switch result{
            case .success(let Products):
                DispatchQueue.main.async{
                self?.products = Products
                self?.collectionOutlet.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct product {
    var image: String
    var name: String
    var color: String
    var price: String
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell" , for: indexPath) as! CollectionViewCell
       
        let product = products[indexPath.row]
        cell.deviceImage.kf.setImage(with: URL(string: product.image))
        cell.containerView.layer.cornerRadius = cell.containerView.frame.width/10
        cell.deviceImage.layer.masksToBounds = true
        cell.phoneName.text = product.name
        cell.phonePrice.text = product.price
        cell.phoneColor.text = product.color
        return cell
    }
    
    
}

