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
    
    func getCell(byIndex id: Int, cell: CustomCell, section: Int) -> CustomCell {
        let type = (section == 0) ? "Meals" : "Drinks"
        let preset = cell
        let fetchedMeal = db?.fetchFood(byIndex: id, type: type)
        let id = fetchedMeal?.value(forKey: "id") as! Int32
        
        preset.img.image = UIImage(data: (fetchedMeal?.value(forKey: "image") as! Data))
        preset.ingredients.text = fetchedMeal?.value(forKey: "ingredients") as! String
        preset.name.text = fetchedMeal?.value(forKey: "name") as! String
        preset.restorationIdentifier = String(id)
        
        return preset
    }
}
