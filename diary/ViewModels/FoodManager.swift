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
        var res: [NSManagedObject] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            try res = (context?.fetch(request))!
        } catch {
            print("Error fetching data: \(type)")
        }
        return res
    }

    
    // MARK: - Fetch only one object
    func fetchFood(byIndex id: Int, type: String) -> NSManagedObject {
        return fetchFood(type: type)[id]
    }

    func fetchFood(byId id: Int, type: String) -> NSManagedObject {
        var obj = NSManagedObject()
        for food in fetchFood(type: type){
            if food.value(forKey: "id") as! Int16 == id {
                obj = food
                break
            }
        }
        return obj
    }
    
    
    func fetchCount(type: String) -> Int16 {
        return Int16(fetchFood(type: type).count)
    }
    
    
    // MARK: - Add an object to DB
    func addFood(id: Int16, name: String, ingredients: String, image: NSData , type: String){
        
        let entity = NSEntityDescription.entity(forEntityName: "\(type)", in: context!)
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        
        storedItem.setValue(id, forKey: "id")
        storedItem.setValue(name, forKey: "name")
        storedItem.setValue(ingredients, forKey: "ingredients")
        print("values setted")
        storedItem.setValue(image, forKey: "image")
        print("image setted")
        
        do {
            try context?.save()
            print("\(name) saved succesfully")
        } catch {
            print("Error saving \(name) to DB")
        }
    }
    
    func removeFood(byId id: Int, type: String){
        let food = fetchFood(byId: id, type: type)
        context?.delete(food)
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
