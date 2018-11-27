//
//  CreateMealViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateFoodViewController: UIViewController {

    
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    var disposer = DisposeBag()
    
    var imgPicker = UIImagePickerController()
    var imagePicked = Variable(false)
    
    // vm - ViewModel
    var vm: CreateFoodViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.isEnabled = false
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.createFood
        
        setVMType()
        configPlaceholder()
        configImgPicker()
        createImgTapRecognizer()
    }
    
    
    func setVMType(){
        let type = (navBar.title == "Add Drink") ? "Drinks" : "Meals"
        vm?.type = type
    }
    
    
    // MARK: - Button controllers
    @IBAction func btnAddClicked(_ sender: Any) {
        img.image = vm?.resize(To: 120, image: img.image!)
        if !(vm!.isFullDescribed(ingredients: ingredients, name: name, imgPicked: imagePicked.value)) {
            self.present((vm!.getMissingAlert()), animated: true, completion: nil)
            return
        }
        vm?.addMeal(ingredients: ingredients.text, name: name.text!, img: img)
        navigationController?.popViewController(animated: true)
    }
    

    // RxSettings ####
    private func setupCardImageDisplay() {
        imagePicked.asObservable().subscribe({ _ in
                self.validate()
        }).disposed(by: disposer)
    }
    private func setupIngredientsValidating() {
        let validDescription = ingredients.rx.text
            .throttle(0.1, scheduler: MainScheduler.instance).map { _ in }
        
        validDescription.subscribe({ _ in self.validate() }).disposed(by: disposer)
    }
    private func setupNameValidating() {
        let validDescription = name.rx.text
            .throttle(0.1, scheduler: MainScheduler.instance).map { _ in }
        
        validDescription.subscribe({ _ in self.validate() }).disposed(by: disposer)
    }
    private func validate(){
        btnAdd.isEnabled  = vm!.isFullDescribed(ingredients: ingredients, name: name, imgPicked: imagePicked.value)
    }
}



// MARK: - CREATE VIEW
extension CreateFoodViewController: UITextViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Placeholder settings
    func configPlaceholder(){
        ingredients.text = "Ingredients..."
        ingredients.textColor = UIColor.lightGray
        ingredients.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ingredients..."
            textView.textColor = UIColor.lightGray
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setupIngredientsValidating()
        setupNameValidating()
        setupCardImageDisplay()
    }
}



// MARK: - IMAGE PICKER CONTROLLER
extension CreateFoodViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func configImgPicker(){
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary;
    }
    
    func createImgTapRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateFoodViewController.imageTapped(gesture:)))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            img.image = vm?.resize(To: 300, image: image)
            img.clipsToBounds = true
        }
        dismiss(animated: true, completion: {() in
            self.imagePicked.value = true
            
        })
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ingredients: UILabel!

}


















// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
