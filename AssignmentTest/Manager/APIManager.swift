//
//  APIManager.swift
//  APIDemo
//

import Foundation
import UIKit

class APIManager {
    
    static let shared: APIManager = {
        
        let instance = APIManager()
        return instance
        
    }()
    
    func searchByDateWith(tag: String, page: String, complition:@escaping([Hits]?, Bool?, String?,Int?,Int?)->()) {
        
        let strUrl = "https://hn.algolia.com/api/v1/search_by_date?tags=" + tag + "&page=" + page
        let url = URL(string: strUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.httpMethod = "GET"
        
        var arrHitsData:[Hits] = []
        
        do {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, errorResponse) in
                
                if errorResponse != nil {
                    
                    print(errorResponse!)
                    complition(arrHitsData, false, errorResponse! as? String,0, 0)
                }
                else{
                    
                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                        {
                            
                            if let arrayHits = dictionary["hits"] as? [[String:Any]] {
                                for obj in arrayHits {
                                    
                                    arrHitsData.append(Hits(Dictionary: obj))
                                }
                                let page = dictionary["page"] as? Int
                                let totalPages = dictionary["nbPages"] as? Int
                                complition(arrHitsData, true, "",page, totalPages)
                            }else {
                                complition([], false, "Data not Found.",0, 0)
                            }
                            
                        }
                    }
                    catch let exeptionError as Error? {
                        print(exeptionError!.localizedDescription)
                        complition([], false, exeptionError?.localizedDescription,0, 0)
                    }
                }
            })
            
            task.resume()
        } catch let error as Error! {
            complition([], false, error!.localizedDescription,0,0)
        }
    }
}
