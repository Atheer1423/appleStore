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
        database.child("\(SafeEmail)").observe(.value) { snapshot in
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
    public func addToFavourites(_ product:product , _ email:String, completion: @escaping (_ success:Bool)-> Void){
    let SafeEmail = safeEmail(email: email)
        database.child("\(SafeEmail)").observeSingleEvent(of: .value) {[weak self] snapshot in
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
                    "color" : product.color,
                    "id" : product.id
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
    
    public func deleteProduct(id : String, completion: @escaping (_ success : Bool) -> Void) {
        let SafeEmail = safeEmail(email: "Atheersalalha@hotmail.com")
        database.child("\(SafeEmail)").observe(.value) { snapshot in
            guard var value  = snapshot.value as? [[String:Any]] else {
                print(DatabaseError.failedToFetch)
                completion(false)
                return
            }
            var index = 0
            value.forEach { dic in
               let productId =  dic["id"] as? String
                if  productId == id {
                    value.remove(at: index)
                    self.database.child("\(SafeEmail)").setValue(value, withCompletionBlock: { error, _ in
                        
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
