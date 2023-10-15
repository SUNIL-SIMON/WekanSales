//
//  Model.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import UIKit
import RealmSwift
public struct Sales : Decodable{
    var documents = List<Document>()
}
public class Document : Object, Decodable{
    @objc dynamic var _id = String()
    @objc dynamic var saleDate = String()
    var items = List<Item>()
    @objc dynamic var storeLocation = String()
    @objc dynamic var customer : Customer!
    @objc dynamic var couponUsed = Bool()
    @objc dynamic var purchaseMethod = String()
}
public class Item : Object, Decodable{
    @objc dynamic var name = String()
    var tags = List<String>()
    @objc dynamic var price = String()
    @objc dynamic var quantity = Int()
}
public class Customer : Object, Decodable{
    @objc dynamic var gender = String()
    @objc dynamic var age = Int()
    @objc dynamic var email = String()
    @objc dynamic var satisfaction = Float()
}

