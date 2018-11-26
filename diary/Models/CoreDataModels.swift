//
//  CoreDataModels.swift
//  diary
//
//  Created by Victor on 11/26/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class FoodModel {
    var id: Int32?
    var image: NSData?
    var ingredients: String?
    var name: String?
}

class ConsumedModel {
    var id: Int32?
    var selfId: Int32?
    var quantity: String?
}

class DayModel {
    var date: String?
}
