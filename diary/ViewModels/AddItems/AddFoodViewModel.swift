//
//  AddMealViewModel.swift
//  diary
//
//  Created by Victor on 11/14/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class AddFoodViewModel {
    
    var db = FoodManager.instance
    var type: String?
    
    func addConsumedMeal(id: Int, quantity: Int){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let time : String = formatter.string(from: Date())
        if !(db.existDay(date: time)) {
            db.addDate(date: time)
        }
        db.addFoodToDate(date: time, foodType: type!, foodId: id, quantity: String(quantity))
    }
    
    func getAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    func isCorrectNumber(q: String) -> Bool {
        if Int(q) == nil {
            return false
        } else if Int(q)! < 1 || q.count > 5 {
            return false
        }
        return true
    }
}
