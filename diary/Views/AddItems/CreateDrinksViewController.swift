//
//  CreateMealViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class CreateDrinkViewController: UIViewController {
    
    

    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    
    var imgPicker = UIImagePickerController()
    var imagePicked = false
    
    // vm - ViewModel
    var vm: CreateDrinkViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.createDrink
        
        configPlaceholder()
        configImgPicker()
        createImgTapRecognizer()
    }
    
    
    // MARK: - Button controllers
    @IBAction func btnAddClicked(_ sender: Any) {
        if !(vm!.isFullDescribed(ingredients: ingredients, name: name, imgPicked: imagePicked)) {
            self.present((vm!.getMissingAlert()), animated: true, completion: nil)
            return
        }
        vm?.addMeal(ingredients: ingredients.text, name: name.text!, img: img)
        navigationController?.popViewController(animated: true)
    }
}



// MARK: - CREATE VIEW
extension CreateDrinkViewController: UITextViewDelegate {
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
}



// MARK: - IMAGE PICKER CONTROLLER
extension CreateDrinkViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func configImgPicker(){
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary;
        imgPicker.allowsEditing = false
    }
    
    func createImgTapRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateMealViewController.imageTapped(gesture:)))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img.image = image
        }
        dismiss(animated: true, completion: {() in
            self.imagePicked = true
        })
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ingredients: UILabel!
}

















