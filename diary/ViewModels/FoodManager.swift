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
    
    var populated = false

    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var frc: NSFetchedResultsController<NSFetchRequestResult>!
    private var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    init() {
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchRequest?.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: context!,
                                         sectionNameKeyPath: nil, cacheName: nil)
        
        populateDataBase()
        /*populated = UserDefaults.standard.bool(forKey: "popolated")
         if !populated {
         populateDataBase()
         UserDefaults.standard.set(true, forKey: "populated")
         }*/
    }
    
    
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

    
    func fetchFood(byIndex id: Int, type: String) -> NSManagedObject {
        var foundedFood = NSManagedObject()
        for food in fetchFood(type: type) {
            if food.value(forKey: "id") as! Int == id {
                foundedFood = food
                break
            }
        }
        return foundedFood
    }

    func fetchFood(byId id: Int, type: String) -> NSManagedObject {
        var obj = NSManagedObject()
        for food in fetchFood(type: type){
            if food.value(forKey: "id") as! Int32 == id {
                obj = food
                break
            }
        }
        return obj
    }
    
    
    func fetchCount(type: String) -> Int16 {
        return Int16(fetchFood(type: type).count)
    }
    
    func addFood(id: Int32, name: String, ingredients: String, image: NSData , type: String){
        
        print("NEW ITEM ADDING ####")
        print("id \(id)")
        print("name \(name)")
        print("ingredients \(ingredients)")
        
        let entity = NSEntityDescription.entity(forEntityName: "\(type)", in: context!)
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        
        storedItem.setValue(id, forKey: "id")
        storedItem.setValue(name, forKey: "name")
        storedItem.setValue(ingredients, forKey: "ingredients")
        storedItem.setValue(image, forKey: "image")
        
        saveContext()
    }
    
    func removeFood(byId id: Int, type: String){
        let food = fetchFood(byId: id, type: type)
        context?.delete(food)
        saveContext()
    }
    
    
    
    // MARK: -  HISTORY METHODS ######
    func fetchHistory() -> [NSManagedObject] {
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching history")
        }
        return frc.sections?[0].objects as! [NSManagedObject]
    }
    
    func fetchHistoryCount() -> Int {
        return fetchHistory().count
    }
    
    func fetchHistory(byIndex id: Int) -> NSManagedObject {
        return fetchHistory()[id]
    }
    
    func existDay(date: String) -> Bool {
        for day in fetchHistory() {
            if day.value(forKey: "date") as! String == date {
                return true
            }
        }
        return false
    }
    
    
    func addDate(date: String){
        let entity = NSEntityDescription.entity(forEntityName: "Days", in: context!)
        let stored = NSManagedObject(entity: entity!, insertInto: context)
        
        stored.setValue(date, forKey: "date")
        saveContext()
    }
    
    
    func addFoodToDate(date: String, foodType: String, foodId: Int, quantity: Int){
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchReq.predicate = NSPredicate(format: "date = %@", date)
        
        let foodEntity = NSEntityDescription.entity(forEntityName: foodType, in: context!)
        let food = NSManagedObject(entity: foodEntity!, insertInto: context)
        
        food.setValue(foodId, forKey: "id")
        food.setValue(quantity, forKey: "quantity")
        
        if let fetchResults = try? context?.fetch(fetchReq) as? [NSManagedObject] {
            let day = fetchResults![0]
            let key = (foodType == "MealConsumed") ? "meals" : "drinks"
            day.mutableSetValue(forKey: key).add(food)
        }
        saveContext()
    }

    
    func getFood(byDate date: String, type: String) -> [NSManagedObject] {
        findDay(byDate: date)
        
        let day = frc.sections?[0].objects![0] as! NSManagedObject
        let foodIds = day.value(forKey: type) as! NSSet
        
        return foodIds.allObjects as! [NSManagedObject]
    }
    
    func getFoodCountByDate(date: String, type: String) -> Int {
        print("returned \(getFood(byDate: date, type: type).count) of type \(type)")
        return getFood(byDate: date, type: type).count
    }
    
    func deleteHistory(date: String){
        
    }
    
    // MARK: - Helpers
    func saveContext(){
        do {
            try context?.save()
        } catch {
            print("Error saving context")
        }
    }
    
    func findDay(byDate date: String){
        let predicate = NSPredicate(format: "date == %@", date)
        frc.fetchRequest.predicate = predicate
        do {
            try frc.performFetch()
        } catch {
        }
    }
    
    
    func populateDataBase(){
        
        func populateFood(type: String, myDict: NSDictionary) {
            for i in 1...(myDict["\(type)Count"] as! Int) {
                
                var imgData: NSData?
                let path = ((myDict["\(type)\(i)"] as! NSDictionary)["image"]) as! String
                if let filePath = Bundle.main.path(forResource: path, ofType: ""), let image = UIImage(contentsOfFile: filePath) {
                    imgData = UIImagePNGRepresentation(image)! as NSData
                }
                let ingredients = ((myDict["\(type)\(i)"] as! NSDictionary)["ingredients"])!
                let name = ((myDict["\(type)\(i)"] as! NSDictionary)["name"])!
                let id = ((myDict["\(type)\(i)"] as! NSDictionary)["id"])!
                
                addFood(id: id as! Int32, name: name as! String, ingredients: ingredients as! String, image: imgData!, type: "\(type)s")
            }
        }
        
        if let path = Bundle.main.path(forResource: "Food", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path)
        {
            populateFood(type: "Meal", myDict: myDict)
            populateFood(type: "Drink", myDict: myDict)
        }
    }
}







