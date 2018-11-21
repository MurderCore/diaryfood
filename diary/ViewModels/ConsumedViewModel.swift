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
    
    var db: FoodManager?
    
    var consumedMeal: [NSManagedObject]?
    var consumedDrink: [NSManagedObject]?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    func getRowsNumb(forSection id: Int, date: String) -> Int {
        if id == 0 {
            return (consumedMeal?.count)!
        }
        return (consumedDrink?.count)!
    }
    
    func getCell(date: String, byIndex id: Int, cell: CustomCell, section: Int) -> CustomCell {
        
        let type = (section == 0) ? "Meals" : "Drinks"
        let typeConsumed = (type == "Drinks") ? "DrinkConsumed" : "MealConsumed"
        
        let preset = cell
        let fetchedConsumed = db?.fetchConsumed(byIndex: id, type: typeConsumed, date: date)
        let foodId = (fetchedConsumed?.value(forKey: "id") as! Int32)
        print("Consumed food id \(foodId)")
        let fetchedMeal = db?.fetchFood(byId: Int(foodId), type: type)
        let id = fetchedConsumed?.value(forKey: "selfId") as! Int32

        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = "Food id: \(foodId)" //"\(fetchedConsumed?.value(forKey: "quantity") as! String)g"
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = String(id)
        
        return preset
    }

    func existFoodAtDate(date: String) -> Bool {
        if consumedDrink?.count == 0 &&
            consumedMeal?.count == 0 {
            db?.deleteHistory(date: date)
            return false
        }
        return true
    }
    
    func deleteFoodFromDate(date: String, type: String, id: String){
        db?.deleteFoodFromDate(date: date, type: type, foodId: Int(id)!)
        updateFoods(date: date)
    }
    
    func updateFoods(date: String){
        consumedMeal = db?.getConsumed(date: date, type: "meals")
        consumedDrink = db?.getConsumed(date: date, type: "drinks")
    }
}



