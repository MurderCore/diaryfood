//
//  AddMealViewModel.swift
//  diary
//
//  Created by Victor on 11/14/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class AddFoodViewModel {
    
    var db: FoodManager?
    var type: String?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    func addConsumedMeal(id: Int, quantity: Int){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let time : String = formatter.string(from: Date())
        if !(db?.existDay(date: time))! {
            db?.addDate(date: time)
        }
        db?.addFoodToDate(date: time, foodType: type!, foodId: id, quantity: String(quantity))
    }
    
    func getAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}