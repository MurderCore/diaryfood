//
//  FoodManager.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit
import CoreData

class FoodManager {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    // MARK: - Fetch all data
    func fetchFood(type: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            return (try context?.fetch(request))!
        } catch {
            print("Error fetching data: \(type)")
        }
    }

    
    // MARK: - Fetch only one object
    func fetchMeal(id: Int) -> NSManagedObject {
        return fetchFood(type: "Meals")[id]
    }
    func fetchDrink(id: Int) -> NSManagedObject {
        return fetchFood(type: "Drinks")[id]
    }
    
    
    func fetchCount(type: String) -> Int {
        return fetchFood(type: type).count
    }
    
    
    // MARK: - Add an object to DB
    func addFood(_ food: Food, type: String){
        
        let entity = NSEntityDescription.entity(forEntityName: "\(type)", in: context!)
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        storedItem.setValues(meal: food)
        
        do {
            try context?.save()
        } catch {
            print("Error saving data to DB")
        }
    }
}


extension NSManagedObject {
    func setValues(meal: Food){
        self.setValue(meal.id, forKey: "id")
        self.setValue(meal.name, forKey: "name")
        self.setValue(meal.ingredients, forKey: "ingredients")
        self.setValue(meal.image, forKey: "image")
    }
}


/*
class Blabla {
    
    func save(item: Item, labels: [Label]) {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context!)
        
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        storedItem.setValue(item.name, forKey: "name")
        storedItem.setValue(NSSet(objects: labels), forKey: "labels")
        
        do {
            try context?.save()
            items.append(storedItem)
        } catch {
            print("Saving data error")
        }
        
    }
    
    func fetchData(){
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Items")
        
        do {
            try items = (context?.fetch(request))!
        } catch {
            print("Error fetching data")
        }
    }
}
 */
