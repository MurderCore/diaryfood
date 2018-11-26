//
//  CreateMealViewModel.swift
//  diary
//
//  Created by Victor on 11/13/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class CreateFoodViewModel {
    
    var db = FoodManager.instance
    var missing = ""
    var type: String?
    
    
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
        let alert = UIAlertController(title: "Incomplete description", message: "Missing \(missing)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    
    func addMeal(ingredients: String, name: String, img: UIImageView){
        
        let key = (type! == "Drinks") ? "plistDrinks" : "plistMeals"
        let imgData: NSData = img.image!.pngData()! as NSData
        var id = UserDefaults.standard.integer(forKey: key)
        
        db.addFood(id: Int32(id), name: name, ingredients: ingredients, image: imgData, type: type!)
        
        id += 1;
        UserDefaults.standard.set(id, forKey: key)
    }
    
    func resize(To size: Int, image: UIImage) -> UIImage {
        
        let lessSize = (image.size.width < image.size.height) ? image.size.width : image.size.height
        
        let scaleCoeff = CGFloat(size) / lessSize
        let newWidth = (image.size.width) * scaleCoeff
        let newHeight = (image.size.height) * scaleCoeff
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}









