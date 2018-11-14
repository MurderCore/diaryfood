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
    @NSManaged var date: String
    @NSManaged var meals: NSSet
    @NSManaged var drinks: NSSet
}

class Drink: Food {
}

class Meal: Food {
}

class Food {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var ingredients: String
    @NSManaged var image: NSData
}

class DrinkConsumed: Consumed {
}
class MealConsumed: Consumed {
}

class Consumed {
    @NSManaged var id: Int32
    @NSManaged var quantity: Int16
}
