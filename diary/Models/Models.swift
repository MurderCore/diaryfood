//
//  Models.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation
import CoreData

class Day {
    @NSManaged var date: Date
    @NSManaged var meals: NSSet
    @NSManaged var drinks: NSSet
}

class Drink: Food {
}

class Meal: Food {
}

class Food {
    @NSManaged var id: Int16
    @NSManaged var name: String
    @NSManaged var ingredients: String
    @NSManaged var image: String
}
