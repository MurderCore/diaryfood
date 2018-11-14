//
//  DrinksViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//


import UIKit

class DrinksViewModel {
    
    var db: FoodManager?
    
    init(foodManager: FoodManager) {
        self.db = foodManager
    }
    
    func getRowsCount() -> Int {
        return Int((db?.fetchCount(type: "Drinks"))!)
    }
    
    func getCell(byIndex id: Int, cell: CustomCell) -> CustomCell {
        let preset = cell
        let fetchedMeal = db?.fetchFood(byIndex: id, type: "Drinks")
        let id = fetchedMeal?.value(forKey: "id") as! Int32
        
        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = fetchedMeal?.value(forKey: "ingredients") as! String
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = String(id)
        
        print("cell id is \(id)")
        
        return preset
    }
    
    func remove(atId id: Int){
        db?.removeFood(byId: id, type: "Drinks")
    }
}
