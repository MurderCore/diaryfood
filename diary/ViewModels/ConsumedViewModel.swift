//
//  ConsumedViewModel.swift
//  diary
//
//  Created by Victor on 11/14/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class ConsumedViewModel {
    
    var db: FoodManager?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    func getRowsNumb(forSection id: Int, date: String) -> Int {
        let type = (id == 0) ? "meals" : "drinks"
        return (db?.getFoodCountByDate(date: date, type: type))!
    }
    
    func getCell(date: String, byIndex id: Int, cell: CustomCell, section: Int) -> CustomCell {
        
        let type = (section == 0) ? "Meals" : "Drinks"
        let typeConsumed = (type == "Drinks") ? "DrinkConsumed" : "MealConsumed"
        
        let preset = cell
        let fetchedConsumed = db?.fetchConsumed(byIndex: id, type: typeConsumed, date: date)
        let foodId = (fetchedConsumed?.value(forKey: "id") as! Int32)
        let fetchedMeal = db?.fetchFood(byId: Int(foodId), type: type)
        let id = fetchedConsumed?.value(forKey: "selfId") as! Int32

        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = "\(fetchedConsumed?.value(forKey: "quantity") as! String)g"
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = String(id)
        
        return preset
    }

    func existFoodAtDate(date: String) -> Bool {
        return db!.checkIfFoodLeft(atDate: date)
    }
    
    func deleteFoodFromDate(date: String, type: String, id: String){
        db?.deleteFoodFromDate(date: date, type: type, foodId: Int(id)!)
    }
}
