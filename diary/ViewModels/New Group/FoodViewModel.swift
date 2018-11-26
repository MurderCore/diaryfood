//
//  MealsViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//


import UIKit
import CoreData

class FoodViewModel {
    
	var food: [FoodModel]?

    var db = FoodManager.instance
    var type: String?
    
    func getRowsCount() -> Int {
        return Int((db.fetchCount(type: type!)))
    }
    
	func getCell(byIndex id: Int, cell: CustomCell) -> CustomCell {
        let preset = cell
        let meal = food![id]
        
        preset.img.image = UIImage(data: meal.image as! Data)
        preset.ingredients.text = meal.ingredients
        preset.name.text = meal.name
        preset.restorationIdentifier = String(meal.id!)
        
        return preset
    }

	func updateFood(){
        food = db.fetchFood(type: type!)
	}
    
    func remove(atId id: Int){
        db.removeFood(byId: id, type: type!)
    }
}
