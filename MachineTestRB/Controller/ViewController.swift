//
//  ViewController.swift
//  MachineTestRB
//
//  Created by Ashwini on 01/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textEmailId: UITextField!
    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textDOB: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var gender : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        genderSegment.tintColor = UIColor.init(displayP3Red: 31.0/255.0, green: 61.0/255.0, blue: 99.0/255.0, alpha: 1)
        btnSubmit.layer.cornerRadius = 4
        self.textDOB.setInputViewDatePicker(target: self, selector: #selector(tapDone(sender:datePicker1:)))
        gender = messages.male
    }
    
    
    @objc func tapDone(sender: Any, datePicker1: UIDatePicker) {
        print(datePicker1)
        if let datePicker = self.textDOB.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.textDOB.text = dateformatter.string(from: datePicker.date)
        }
        self.textDOB.resignFirstResponder()
    }
    
    func getCurrentLocation()
    {
        CurrentLocation.currentLocation.delegate = self
        CurrentLocation.currentLocation.getUserCurrentLocation()
    }
    
    @IBAction func genderSegmentTapped(_ sender: UISegmentedControl) {
        let tag = sender.selectedSegmentIndex
        print(tag)
        switch tag{
        case 0:
            gender = messages.male
        case 1:
            gender = messages.female
        default:
            gender = messages.male
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        let reason = validateFields()
        if(reason == messages.empty)
        {
            AlertView.alertView.showAlert(message: messages.success, imageName: images.success, btnTitle: .Success)

            
        }else{
            AlertView.alertView.showAlert(message: reason, imageName: images.failed, btnTitle: .Success)
        }
    }
    
    func validateFields() -> String{
        guard let email = textEmailId.text, !email.isEmpty else {
            return messages.emptyEmail
        }
        guard email.validateEmail() else{
            return messages.invalidEmail
        }

        guard  let mobileNo = textPhoneNumber.text, !mobileNo.isEmpty else {
            return messages.emptyPhone
        }
        
         guard mobileNo.isPhoneNumber else{
            return messages.invalidPhone
         }
        guard  let dob = textDOB.text, !dob.isEmpty else {
            return messages.emptyDob
        }
  
        guard ((gender?.isEmpty) != nil) else {
            return messages.emptyGender
        }
   
        return messages.empty
    }
    
}


extension ViewController:CurrentLocationDelegate{
    func displayAddress(currentAddress: String) {
        lblCurrentLocation.text = currentAddress
    }
}

