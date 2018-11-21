//
//  MealsViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//


import UIKit

class FoodViewModel {
    
	var food: [NSManagedObject]?

    var db: FoodManager?
    var type: String?
    
    init(foodManager: FoodManager) {
        self.db = foodManager
    }
    
    func getRowsCount() -> Int {
        return Int((db?.fetchCount(type: type!))!)
    }
    
	func getCell(byIndex id: Int, cell: CustomCell) -> CustomCell {
       		let preset = cell
        	let meal = food[id]
        	let id = meal.value(forKey: "id") as! Int32
        
        	preset.img.image = UIImage(data: (meal?.value(forKey: "image") as! Data))
        	preset.ingredients.text = meal?.value(forKey: "ingredients") as! String
        	preset.name.text = meal?.value(forKey: "name") as! String
        	preset.restorationIdentifier = String(id)
        
        	return preset
    	}

    /*func getCell(byIndex id: Int, cell: CustomCell) -> CustomCell {
        let preset = cell
        let fetchedMeal = db?.fetchFood(byIndex: id, type: type!)
        let id = fetchedMeal?.value(forKey: "id") as! Int32
        
        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = fetchedMeal?.value(forKey: "ingredients") as! String
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = String(id)
        
        return preset
    }*/

	func updateFood(){
		food = db?.fetchFood(type: type!)
	}
    
    func remove(atId id: Int){
        db?.removeFood(byId: id, type: type!)
    }
}
