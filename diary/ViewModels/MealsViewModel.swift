//
//  MealsViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class MealsViewModel {
    
    var db: FoodManager?
    
    init(foodManager: FoodManager) {
        self.db = foodManager
    }
    
    func getRowsCount() -> Int {
        return Int((db?.fetchCount(type: "Meals"))!)
    }
    
    func getCell(byIndex id: Int, cell: CustomCell) -> CustomCell {
        let preset = cell
        let fetchedMeal = db?.fetchFood(byIndex: id, type: "Meals")
        
        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = fetchedMeal?.value(forKey: "ingredients") as! String
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = (fetchedMeal?.value(forKey: "id"))! as? String
        
        print("cell id seeted as \(preset.restorationIdentifier)")
        
        return preset
    }
    
    func remove(atId id: Int){
        db?.removeFood(byId: id, type: "Meals")
    }
}
