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
                let imageUrl = dic["imageUrl"] as? String else{
                    return nil
                }
                return product(image: imageUrl, name: name, color: color, price: price)
                
            }
            )
            completion(.success(products))
            
        }
        )
        
    }
    
    public func getFavouritesProducts(_ email:String, completion: @escaping (Result<[product],Error>) -> Void) {
        let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let productsFav : [product] =  value.compactMap({ productDic in
               guard let name = productDic["name"] as? String ,
                   let price = productDic["price"] as? String ,
                   let color = productDic["color"] as? String ,
                   let imageUrl = productDic["imageUrl"] as? String else {
                   return nil
               }
                return product(image: imageUrl, name: name, color: color, price: price)
            })
            completion(.success(productsFav))
        }
        
        
    }
    public func addToFavourites(_ product:product , _ email:String, completion: @escaping (_ success:Bool)-> Void){
    let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)").observeSingleEvent(of: .value) {[weak self] snapshot in
            if var value = snapshot.value  as? [[String: Any]]{
                let newProduct =
                [
                    "name" : product.name,
                    "price" : product.price,
                    "imageUrl" : product.image,
                    "color" : product.color
                ]
                value.append(newProduct)
                self?.database.child("\(SafeEmail)").setValue(value, withCompletionBlock: { error, _ in
                    
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
                    "color" : product.color
                ]
                ]
                self?.database.child("\(SafeEmail)").setValue(newProduct, withCompletionBlock: { error, _ in
                    
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
    
}

public enum DatabaseError  : Error {
    case failedToFetch
    
}
