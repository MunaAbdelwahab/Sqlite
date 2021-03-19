//
//  Friend.swift
//  SqlLite
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import Foundation

class Friend : NSObject {
    
    var name : String?
    var phone : String?
    var age : Int64?
    var image : String?
    var id : Int?
    
    override init() {
            self.name = "name"
            self.phone = "phone"
            self.age = 20
            self.image = "image"
            self.id = 5
        }
    
    init(name : String, phone : String, age : Int64, image : String, id : Int) {
        self.name = name
        self.phone = phone
        self.age = age
        self.image = image
        self.id = id
    }
}
