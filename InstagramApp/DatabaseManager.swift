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
}

public enum DatabaseError  : Error {
    case failedToFetch
    
}
