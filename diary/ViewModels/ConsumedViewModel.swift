//
//  ConsumedViewModel.swift
//  diary
//
//  Created by Victor on 11/14/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit
import CoreData

class ConsumedViewModel {
    
    var db = FoodManager.instance
    
    var consumedMeal: [NSManagedObject]?
    var consumedDrink: [NSManagedObject]?
    
    func getRowsNumb(forSection id: Int, date: String) -> Int {
        if id == 0 {
            return (consumedMeal?.count)!
        }
        return (consumedDrink?.count)!
    }


	func getCell(date: String, byIndex id: Int, cell: CustomCell, section: Int) -> CustomCell {
		let preset = cell
        let consumed = (section == 0) ? consumedMeal![id] : consumedDrink![id]

		let foodId = consumed.value(forKey: "id") as! Int32
		let type = (section == 0) ? "Meals" : "Drinks"

        let meal = db.fetchFood(byId: Int(foodId), type: type)
        let id = consumed.value(forKey: "selfId") as! Int

		preset.img.image = UIImage(data: (meal?.value(forKey: "image") as! Data))
        preset.ingredients.text = "\(consumed.value(forKey: "quantity") as! String)g"
        preset.name.text = meal?.value(forKey: "name") as? String
        preset.restorationIdentifier = String(id)

		return preset
	}
    
    func existFood(atDate date: String) -> Bool {
        return (db.checkIfFoodLeft(atDate: date))
    }
    
// CALL ONLY checkIfFoodLeft to remove a day
    
    func deleteFoodFromDate(date: String, type: String, id: String){
        db.deleteFoodFromDate(date: date, type: type, foodId: Int(id)!)
        updateFoods(date: date)
    }
    
    func updateFoods(date: String){
        consumedMeal = db.getConsumed(date: date, type: "meals")
        consumedDrink = db.getConsumed(date: date, type: "drinks")
    }
}



