//
//  Hits.swift
//  AssignmentTest
//

import UIKit

class Hits: NSObject {

    var lblTitle:String!
    var lblDate:String!
    var isSelected :Bool = false
    
    init(Dictionary:[String:Any]) {
        lblTitle = "\(Dictionary["title"] ?? "")"
        lblDate = "\(Dictionary["created_at"] ?? "")"
        
    }
    
}
