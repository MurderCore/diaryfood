//
//  CreateMealViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class CreateFoodViewController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    
    var imgPicker = UIImagePickerController()
    var imagePicked = false
    
    // vm - ViewModel
    var vm: CreateFoodViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        img.image = resize(To: 60, image: img.image!)
        if !(vm!.isFullDescribed(ingredients: ingredients, name: name, imgPicked: imagePicked)) {
            self.present((vm!.getMissingAlert()), animated: true, completion: nil)
            return
        }
        vm?.addMeal(ingredients: ingredients.text, name: name.text!, img: img)
        navigationController?.popViewController(animated: true)
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
}



// MARK: - IMAGE PICKER CONTROLLER
extension CreateFoodViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func configImgPicker(){
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary;
        imgPicker.allowsEditing = true
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img.image = resize(To: 300, image: image)
            img.clipsToBounds = true
        }
        dismiss(animated: true, completion: {() in
            self.imagePicked = true
            
        })
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

class CustomCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ingredients: UILabel!

}

















