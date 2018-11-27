//
//  AddDrinkViewController.swift
//  Food Diary
//
//  Created by Victor on 11/8/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddFoodViewController: UITableViewController, UITextFieldDelegate {
    
    var vm: AddFoodViewModel?
    var foodVM: FoodViewModel?
    
    var lastSelected = 0
    var lastSelectedID = 0
    
    var infoCell: InfoCell?
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    
    let disposer = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDone.isEnabled = false

        foodVM = (navigationController?.viewControllers[0] as! TabBarController).viewModels.food
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.addFood
        
        let type = (navBar.title == "Add Drink") ? "Drinks" : "Meals"
        foodVM?.type = type
        vm?.type = type
    }
    
    
    // MARK: - Button controller
    @IBAction func btnDoneClicked(_ sender: Any) {
        vm?.addConsumedMeal(id: lastSelectedID, quantity: (infoCell?.info.text)!)
        navigationController?.popViewController(animated: true)
    }
    
    
    // ReactX settings
    private func setupTextChangeHandling() {
        let validQuantity = infoCell?.info.rx.text
            .throttle(0.1, scheduler: MainScheduler.instance).map { _ in self.validate() }
        
        validQuantity!.subscribe({ _ in self.validate() }).disposed(by: disposer)
    }
    private func validate(){
        if (lastSelected < 1){
            btnDone.isEnabled = false
            return
        }
        if (vm?.isCorrectNumber(q: (infoCell?.info.text)!))! {
            btnDone.isEnabled = true
        } else {
            btnDone.isEnabled = false
        }
    }
}



// MARK: - Create table
extension AddFoodViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (foodVM?.getRowsCount())! + 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            infoCell?.info.becomeFirstResponder()
            return
        }
        tableView.cellForRow(at: IndexPath(row: lastSelected, section: 0))?.accessoryType = UITableViewCell.AccessoryType.none
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        lastSelected = indexPath.row
        lastSelectedID = Int((tableView.cellForRow(at: IndexPath(row: lastSelected, section: 0))?.restorationIdentifier)!)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let q = (tableView.dequeueReusableCell(withIdentifier: "quantity") as? InfoCell)
            infoCell = q
            infoCell?.info.delegate = self
            return q!
        }
        var cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell)
        cell = foodVM?.getCell(byIndex: indexPath.row-1, cell: cell!)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        foodVM?.updateFood()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTextChangeHandling()
    }
}



class InfoCell: UITableViewCell {
    @IBOutlet weak var info: UITextField!
}










