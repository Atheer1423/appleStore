//
//  ViewController.swift
//  InstagramApp
//
//  Created by administrator on 21/01/2022.
//

import UIKit
import Kingfisher
class ViewController: UIViewController {

    @IBOutlet weak var topLabel2: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var noResultsLabel: UILabel!
    

    @IBOutlet weak var waeBtn: UIButton!
    
    @IBOutlet weak var TabBtn: UIButton!
    @IBOutlet weak var PhBtn: UIButton!
    @IBOutlet weak var BtnBorder: UIButton!
    @IBOutlet weak var categoryStack: UIStackView!
    var SearchProducts : [product] = []
    var products :[product] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
//    var Searchresults :[product] = []
  
    @IBOutlet weak var SearchTableView: UITableView!
    var hasFetched = false
    @IBOutlet weak var collectionOutlet: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        var layout = collectionOutlet.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
//        layout.minimumInteritemSpacing = 5
//        layout.itemSize = CGSize(width:( collectionOutlet.frame.size.width - 20)/2, height: collectionOutlet.frame.size.height / 3)
        fetchData()
        searchBar.delegate = self
        SearchTableView.isHidden = true
       
       
    }
    
    func fetchData(){
      
        DatabaseManager.shared.getProducts(type: "Wearables") { [weak self] result in
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

    @IBAction func TabletsPressed(_ sender: UIButton) {
        UserDefaults.standard.set("jfhgjfkdkskf", forKey: "email")
        print( UserDefaults.standard.value(forKey: "email"))
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
        DatabaseManager.shared.getProducts(type: "phones") { [weak self] result in
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
        DatabaseManager.shared.getProducts(type: "Wearables") { [weak self] result in
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
    func gett(){
        
    }
    
    @IBAction func LabtopPressed(_ sender: UIButton) {
        products = []
        collectionOutlet.reloadData()
        DatabaseManager.shared.getProducts(type: "laptop") { [weak self] result in
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
    var id: String
    var quantity : String?
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell" , for: indexPath) as! CollectionViewCell
       
        let product = products[indexPath.row]
        cell.deviceImage.kf.setImage(with: URL(string: product.image))
        cell.view.layer.cornerRadius = cell.view.frame.width/14

        cell.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner , .layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        cell.phoneName.text = product.name
        cell.phonePrice.text = product.price
        let image = cell.deviceImage.image// your image
        
        if var name =  cell.phoneName.text {
        if ((name.contains("iPhone")) ){
            print("tru")
            UIGraphicsBeginImageContext(CGSize(width: 130, height: 80
                                              ))
             image?.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 130, height: 80)))
             let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             cell.deviceImage.image = scaleImage
        }
        }
       
       UIGraphicsBeginImageContext(CGSize(width: 130, height: 140
                                         ))
        image?.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 130, height: 140)))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.deviceImage.image = scaleImage

       
        
//        cell.containerView.layer.cornerRadius = cell.containerView.frame.width/14
     
//        cell.phoneColor.text = product.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let product  = products[indexPath.row]
        let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetails
        productDetailsVC.product = product
        productDetailsVC.modalPresentationStyle = .fullScreen
        present(productDetailsVC, animated: true, completion: nil)
    }
    
    
}
extension ViewController : UISearchBarDelegate {
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
  
//        topLabel.isHidden = false
//       topLabel2.isHidden = false
       categoryStack.isHidden = false
       SearchTableView.isHidden = true
      collectionOutlet.isHidden = false
       noResultsLabel.isHidden = true
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        print("in search tab")
        SearchTableView.isHidden = false
          guard let text = searchBar.text,!text.replacingOccurrences(of: " ", with: " ").isEmpty else {
              return
          }
        print(text.lowercased())
        SearchProducts.removeAll()
        searchProduct(query: text)
    
    }
    
        func searchProduct(query:String){
            var produ : [product] = []
            var category = ["phones","Tablets","Wearables","laptop"]
            for num in 0...3 {
                
            DatabaseManager.shared.getProducts(type: category[num]) {result in
             
                switch result {
                case .success(let Sproducts):
                   produ = Sproducts
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    return
            }
            
                
                var index = 0
                for dic in produ {
                    let name =  dic.name.lowercased()
                    if name.contains(query.lowercased()) {
                        self.SearchProducts.append(dic)
                    }
                    index = index + 1
                }
                DispatchQueue.main.async{
                 self.SearchTableView.reloadData()
                    if self.SearchProducts.isEmpty {
//                        self.topLabel.isHidden = true
//                        self.topLabel2.isHidden = true
                        self.categoryStack.isHidden = true
                        self.SearchTableView.isHidden = true
                        self.collectionOutlet.isHidden = true
                        self.noResultsLabel.isHidden = false
                    }else{
//                        self.topLabel.isHidden = true
//                        self.topLabel2.isHidden = true
                        self.categoryStack.isHidden = true
                        self.SearchTableView.isHidden = false
                        self.collectionOutlet.isHidden = true
                        self.noResultsLabel.isHidden = true
                    }
            }
            }
           
               }
}
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.Productimage.kf.setImage(with: URL(string: SearchProducts[indexPath.row].image))
        cell.ProductName.text = SearchProducts[indexPath.row].name
        cell.price.text = SearchProducts[indexPath.row].price
        cell.color.text = SearchProducts[indexPath.row].color
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product  = SearchProducts[indexPath.row]
        let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetails
        productDetailsVC.product = product
        productDetailsVC.modalPresentationStyle = .fullScreen
        present(productDetailsVC, animated: true, completion: nil)
    }
    
    
}

