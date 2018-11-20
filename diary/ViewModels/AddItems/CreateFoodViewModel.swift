//
//  CreateMealViewModel.swift
//  diary
//
//  Created by Victor on 11/13/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class CreateFoodViewModel {
    
    var db: FoodManager?
    var missing = ""
    var type: String?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    
    func isFullDescribed(ingredients: UITextView, name: UITextField, imgPicked: Bool) -> Bool {
        if ingredients.text.isEmpty || ingredients.text == "Ingredients..." {
            missing = "ingredients"
            return false
        }
        if (name.text?.isEmpty)! {
            missing = "name"
            return false
        }
        if !imgPicked {
            missing = "image"
            return false
        }
        return true
    }
    
    
    func getMissingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Incomplete description", message: "Missing \(missing)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    
    func addMeal(ingredients: String, name: String, img: UIImageView){
        let count = (db?.fetchCount(type: type!))!
        let imgData: NSData = UIImagePNGRepresentation(img.image!)! as NSData
        db?.addFood(id: Int32(count), name: name, ingredients: ingredients, image: imgData, type: type!)
    }
}









