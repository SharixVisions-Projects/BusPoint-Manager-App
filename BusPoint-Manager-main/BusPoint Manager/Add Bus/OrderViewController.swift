//
//  OrderViewController.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class OrderViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var MianView: UIView!
    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var NumberTF: UITextField!
    @IBOutlet weak var StartTiming: UIDatePicker!
    @IBOutlet weak var DateofDay: UIDatePicker!
    @IBOutlet weak var currentPlaceTF: UITextField!
    @IBOutlet weak var DestinationPlaceTF: UITextField!
    @IBOutlet weak var RouteFairTF: UITextField!
    @IBOutlet weak var OthertF: UITextField!
    
    @IBOutlet weak var UpdateButton: UIButton!


    var pickedImage = UIImage()
    var selectedBusDetail: Bus?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let BusDetail = selectedBusDetail {
            NameTF.text = BusDetail.name
            NumberTF.text = BusDetail.number
//            StartTiming.date = BusDetail.starttiming
//            DateofDay.text = BusDetail.price
            currentPlaceTF.text = BusDetail.currentPlace
            DestinationPlaceTF.text = BusDetail.destination

            RouteFairTF.text = BusDetail.routeFair
            OthertF.text = BusDetail.others
           
        }
        
        if let index = selectedIndex {
            UpdateButton.setTitle("Update", for: .normal)
        }

        applyGradientToButtonThree(view: MianView)
        applyGradientToButtonThree(view: UpdateButton)

        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
     
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // Load data from UserDefaults for Users_Detail
//        if let savedData = UserDefaults.standard.array(forKey: "UserDetails") as? [Data] {
//            let decoder = JSONDecoder()
//            SaleMens_Detail = savedData.compactMap { data in
//                do {
//                    let user = try decoder.decode(SalesPerson.self, from: data)
//                    return user
//                } catch {
//                    print("Error decoding user: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//        }
//        

    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
//    @objc func donePressed() {
//        // Get the date from the picker and set it to the text field
//        if let datePicker = DateofOrder.inputView as? UIDatePicker {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy" // Same format as in convertStringToDate
//            DateofOrder.text = dateFormatter.string(from: datePicker.date)
//        }
//        // Dismiss the keyboard
//        DateofOrder.resignFirstResponder()
//    }

    func makeImageViewCircular(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    private func applyGradientColor(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                UIColor(hex: "#e00056").cgColor, // Purple
                UIColor(hex: "#c80048").cgColor, // Bright Purple
                UIColor(hex: "#ab0037").cgColor, // Violet
                UIColor(hex: "#8a0022").cgColor
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = view.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = view.layer.cornerRadius
            
            // Add the gradient to the button
        view.layer.insertSublayer(gradientLayer, at: 0)
        }
    func clearTextFields() {
        NameTF.text = ""
        NumberTF.text = ""
        currentPlaceTF.text = ""
        RouteFairTF.text = ""
        OthertF.text = ""
        DestinationPlaceTF.text = ""
    }
 

    func saveOrderData(_ sender: Any) {
        // Check if all mandatory fields are filled
        guard let busname = NameTF.text, !busname.isEmpty,
              let busnumber = NumberTF.text, !busnumber.isEmpty,
              let buscurrentPlace = currentPlaceTF.text, !buscurrentPlace.isEmpty,
              let busDestinationtPlace = DestinationPlaceTF.text, !busDestinationtPlace.isEmpty,
              let routefair = RouteFairTF.text, !routefair.isEmpty,
              let other = OthertF.text
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Get the values from UIDatePickers
        let busstarttiming = StartTiming.date // Get the Date
        let dateofday = DateofDay.date        // Get the Date
        
        // Convert busstarttiming to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // Customize format as needed
        let busstarttimingString = dateFormatter.string(from: busstarttiming)
        
        // Generate random character for order number
        let BusId = generateCustomerId()

        // Create new order detail safely
        let newCreateSale = Bus(
            id: "\(BusId)",
            name: busname,
            number: busnumber,
            starttiming: busstarttimingString, // Pass the formatted String
            dayeofday: dateofday,             // Pass the Date directly
            currentPlace: buscurrentPlace, destination: busDestinationtPlace,
            routeFair: routefair,
            others: other
        )
        // Check if editing or creating new entry
        if let index = selectedIndex {
            updateSavedData(newCreateSale, at: index) // Update existing entry
        } else {
            saveCreateSaleDetail(newCreateSale) // Save new entry
        }
        // Save the order detail
      //  saveCreateSaleDetail(newCreateSale)
    }



    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Corrected year format
        return dateFormatter.date(from: dateString)
    }
    // Function to update existing data
    func updateSavedData(_ updatedTranslation: Bus, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "BusesDetails") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "BusesDetails")
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Your Bus Status Has Been Updated Successfully.")
    }
    
    func saveCreateSaleDetail(_ order: Bus) {
        var orders = UserDefaults.standard.object(forKey: "BusesDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(order)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "BusesDetails")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Bus Details has been Added successfully.")
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveOrderData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
