//
//  DatabaseManager.swift
//  InstagramApp
//
//  Created by administrator on 21/01/2022.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager {
    static let shared = DatabaseManager()

    let database = Database.database().reference()
    
    public func safeEmail(email:String) -> String {
     var Safeemail = email.replacingOccurrences(of: ".", with: "-")
    Safeemail = Safeemail.replacingOccurrences(of: "@", with: "-")
        return Safeemail
    }
    
}

extension DatabaseManager {
    
    public func getProducts (type:String,completion:@escaping (Result<[product], Error>)-> Void) {
        
        database.child("\(type)").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
           
            let products: [product] = value.compactMap( { dic in
                
               guard let name = dic["name"] as? String,
                let color = dic["color"] as? String,
                let price = dic["price"] as? String,
                     let id = dic["id"] as? String ,
                let imageUrl = dic["imageUrl"] as? String else{
                    return nil
                }
                return product(image: imageUrl, name: name, color: color, price: price, id: id)
                
            }
            )
            completion(.success(products))
            
        }
        )
        
    }
    
    public func getFavouritesProducts(_ email:String, completion: @escaping (Result<[product],Error>) -> Void) {
        let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)/Fav").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let productsFav : [product] =  value.compactMap({ productDic in
               guard let name = productDic["name"] as? String ,
                   let price = productDic["price"] as? String ,
                   let color = productDic["color"] as? String ,
                    let id = productDic["id"] as? String ,
                   let imageUrl = productDic["imageUrl"] as? String else {
                   return nil
               }
                return product(image: imageUrl, name: name, color: color, price: price , id: id)
            })
            completion(.success(productsFav))
        }
        
        
    }
    
    public func getBasketProducts(_ email:String, completion: @escaping (Result<[product],Error>) -> Void) {
        let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)/basket").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
                print("failure(DatabaseError.failedToFetch)")
            }
            let productsbas : [product] =  value.compactMap({ productDic in
               guard let name = productDic["name"] as? String ,
                   let price = productDic["price"] as? String ,
                   let color = productDic["color"] as? String ,
                    let id = productDic["id"] as? String ,
                   let imageUrl = productDic["imageUrl"] as? String,
                     let quantity = productDic["quantity"] as? String
                else {
                 
                   return nil
               }
               
                return product(image: imageUrl, name: name, color: color, price: price , id: id, quantity:quantity)
            })
           
            completion(.success(productsbas))
        }
        
        
    }
    
    
    public func addProductToBasket(_ product:product , _ email:String, completion: @escaping (_ success:Bool)-> Void){
        let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)/basket").observeSingleEvent( of:.value) {[weak self] snapshot in
                if var value = snapshot.value  as? [[String: Any]]{
                    let newProduct =
                    [
                        "name" : product.name,
                        "price" : product.price,
                        "imageUrl" : product.image,
                        "color" : product.color,
                        "id" : product.id,
                        "quantity" : "1"
                    ]
                    value.append(newProduct)
                    self?.database.child("\(SafeEmail)/basket").setValue(value, withCompletionBlock: { error, _ in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }else{
                            completion(true)
                        }
                    })
                    
                }else{
                    
                    let newProduct: [[String:Any]] =
                    [
                        [
                        "name" : product.name,
                        "price" : product.price,
                        "imageUrl" : product.image,
                        "color" : product.color,
                        "id" : product.id,
                        "quantity" : "1"
                    ]
                    ]
                    self?.database.child("\(SafeEmail)/basket").setValue(newProduct, withCompletionBlock: { error, _ in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }else{
                            completion(true)
                        }
                    })
                    
                }
            }
    }
    
    public func addToFavourites(_ product:product , _ email:String, completion: @escaping (_ success:Bool)-> Void){
    let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)/Fav").observeSingleEvent(of: .value) {[weak self] snapshot in
            if var value = snapshot.value  as? [[String: Any]]{
                let newProduct =
                [
                    "name" : product.name,
                    "price" : product.price,
                    "imageUrl" : product.image,
                    "color" : product.color,
                    "id" : product.id
                ]
                value.append(newProduct)
                self?.database.child("\(SafeEmail)/Fav").setValue(value, withCompletionBlock: { error, _ in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }else{
                        completion(true)
                    }
                })
                
            }else{
                
                let newProduct: [[String:Any]] =
                [
                    [
                    "name" : product.name,
                    "price" : product.price,
                    "imageUrl" : product.image,
                    "color" : product.color,
                    "id" : product.id
                ]
                ]
                self?.database.child("\(SafeEmail)/Fav").setValue(newProduct, withCompletionBlock: { error, _ in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }else{
                        completion(true)
                    }
                })
                
            }
        }
    }
    
    public func getAllProducts( completion: @escaping (_ produxts:[[String:Any]], _ produxts2:[[String:Any]],_ produxts3:[[String:Any]],_ produxts:[[String:Any]]) -> Void){
        var v1 : [[String:Any]]?
        var v2 : [[String:Any]]?
                  var v3 : [[String:Any]]?
                            var v4 : [[String:Any]]?
        database.child("laptop").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String:String]] else{
              print("failed to get products")
                return
            }
           v1 = value
            v2 = value
            v3 = value
            v4 = value
        })
//            database.child("Tablets").observe(.value, with: { snapshot in
//                guard let value1 = snapshot.value as? [[String:Any]] else{
//                  print("failed to get products")
//                    return
//                }
//                v2 = value1
//            })
//                database.child("Wearables").observe(.value, with: { snapshot in
//                    guard let value2 = snapshot.value as? [[String:Any]] else{
//                      print("failed to get products")
//                        return
//                    }
//                    v3 = value2
//
//                })
//                    database.child("phones").observe(.value, with: { snapshot in
//                        guard let value3 = snapshot.value as? [[String:String]] else{
//                          print("failed to get products")
//                            return
//                        }
//                        v4 = value3
//                    })
        print(v4)
             print( v2)
        if let V = v1 ,  let Vt = v2 ,let Vth = v3, let Vf = v4 {
              completion(V,Vt,Vth,Vf)
        }
            
        }
        

    
    
    public func deleteProduct(id : String, _ section: String , completion: @escaping (_ success : Bool) -> Void) {
        let SafeEmail = safeEmail(email: "Atheersalalha@hotmail.com")
        database.child("\(SafeEmail)/\(section)").observe(.value) { snapshot in
            guard var value  = snapshot.value as? [[String:Any]] else {
                print(DatabaseError.failedToFetch)
                completion(false)
                return
            }
            var index = 0
            for dic in value {
               let productId =  dic["id"] as? String
                if  productId == id {
                    value.remove(at: index)
                    self.database.child("\(SafeEmail)/\(section)").setValue(value, withCompletionBlock: { error, _ in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }else{
                            completion(true)
                           
                        }
                    })
                    return
                }else{
                    index+=1
                }
            }
        }

    }
    
    public func editQuantityAndPrice(_ id : String,_ email:String,_ quantity:String, _ price:String, completion: @escaping (_ success : Bool) -> Void) {
        let SafeEmail = safeEmail(email: email)
     
        database.child("\(SafeEmail)/basket").observeSingleEvent(of: .value) { snapshot in
            guard var value  = snapshot.value as? [[String:Any]] else {
                print(DatabaseError.failedToFetch)
              
                completion(false)
                return
            }
          
            var index = 0
            value.forEach {  dic in
               let productId =  dic["id"] as? String
                if  productId == id {
                    let updatedProduct = [
                    "name" : dic["name"] as? String ,
                    "price" : price ,
                    "color" : dic["color"] as? String ,
                    "id" : dic["id"] as? String ,
                    "imageUrl" : dic["imageUrl"] as? String ,
                    "quantity" : quantity
                   ]
                    value[index] = updatedProduct as [String : Any]
                    self.database.child("\(SafeEmail)/basket").setValue(value, withCompletionBlock: { error, _ in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }else{
                            completion(true)
                        }
                    })
                }else{
                    index+=1
                }
            }
        }

    }
    
}

public enum DatabaseError  : Error {
    case failedToFetch
    
}
