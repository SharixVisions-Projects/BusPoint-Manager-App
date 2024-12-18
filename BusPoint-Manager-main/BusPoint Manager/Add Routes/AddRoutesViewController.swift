//
//  AddRoutesViewController.swift
//  BusStand Hub
//
//  Created by Maaz on 27/11/2024.
//

import UIKit

class AddRoutesViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var MianView: UIView!

    @IBOutlet weak var StartTiming: UIDatePicker!
    @IBOutlet weak var DateofDay: UIDatePicker!
    @IBOutlet weak var BusTF: DropDown!
    @IBOutlet weak var StartFromTF: UITextField!
    @IBOutlet weak var DestinationPlaceTF: UITextField!
    @IBOutlet weak var RouteFairTF: UITextField!
    @IBOutlet weak var OthersTF: UITextField!
    @IBOutlet weak var addRouteBtn: UIButton!

    var Bus_Detail: [Bus] = [] // Array of User model objects
    
    var selectedRouteDetail: Routes?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let BusDetail = selectedRouteDetail {
            
            let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Use the format of your string data
             
             // Convert departingTiming string to Date
             if let startDate = dateFormatter.date(from: BusDetail.departingTiming) {
                 StartTiming.date = startDate
             } else {
                 print("Invalid date format for departingTiming: \(BusDetail.departingTiming)")
             }
            
            DateofDay.date = BusDetail.dateofday
            BusTF.text = BusDetail.bus
            StartFromTF.text = BusDetail.startFrom
            DestinationPlaceTF.text = BusDetail.destination
            RouteFairTF.text = BusDetail.routeFair
            OthersTF.text = BusDetail.others
           
        }
        if let index = selectedIndex {
            addRouteBtn.setTitle("Update", for: .normal)
        }
        applyGradientToButtonThree(view: addRouteBtn)
        applyGradientToButtonThree(view: MianView)

        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        BusTF.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data from UserDefaults for Users_Detail
        if let savedData = UserDefaults.standard.array(forKey: "BusesDetails") as? [Data] {
            let decoder = JSONDecoder()
            Bus_Detail = savedData.compactMap { data in
                do {
                    let user = try decoder.decode(Bus.self, from: data)
                    return user
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        // Set up the dropdown options for UserTF
        setUpUserDropdown()

    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    func clearTextFields() {
        RouteFairTF.text = ""
        BusTF.text = ""
        StartFromTF.text = ""
        DestinationPlaceTF.text = ""
        OthersTF.text = ""
        
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
    // Set up User dropdown options from Users_Detail array
    func setUpUserDropdown() {
        // Check if Users_Detail array is empty
        if Bus_Detail.isEmpty {
            // If no users are available, set the text field to "No user available"
            BusTF.text = "No Bus available please first add the Bus"
            BusTF.isUserInteractionEnabled = false // Disable interaction if no users are available
        } else {
            // Extract names from the Users_Detail array
            let userNames = Bus_Detail.map { $0.name }
            
            // Assign names to the dropdown
            BusTF.optionArray = userNames
            
            // Enable interaction if users are available
            BusTF.isUserInteractionEnabled = true
            
            // Handle selection from dropdown
            BusTF.didSelect { (selectedText, index, id) in
                self.BusTF.text = selectedText
                print("Selected user: \(self.Bus_Detail[index])") // Optional: Handle selected user
            }
        }
    }
    func saveRouteData(_ sender: Any) {
        // Check if all mandatory fields are filled
        guard let busname = BusTF.text, !busname.isEmpty,
              let startfrom = StartFromTF.text, !startfrom.isEmpty,
              let destinationplace = DestinationPlaceTF.text, !destinationplace.isEmpty,
              let routefair = RouteFairTF.text, !routefair.isEmpty,
              let other = OthersTF.text
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Get the values from UIDatePickers
        let busstarttiming = StartTiming.date // Get the Date
        let DateOfDay = DateofDay.date        // Get the Date
        
        // Convert busstarttiming to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // Customize format as needed
        let busstarttimingString = dateFormatter.string(from: busstarttiming)

        // Create new order detail safely
        let newCreateSale = Routes(
            bus: busname,
            startFrom: startfrom,
            destination: destinationplace,             // Pass the Date directly
            departingTiming: busstarttimingString,
            dateofday: DateOfDay,
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
    //    saveCreateSaleDetail(newCreateSale)
    }



    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Corrected year format
        return dateFormatter.date(from: dateString)
    }
    // Function to update existing data
    func updateSavedData(_ updatedTranslation: Routes, at index: Int) {
        if var savedData = UserDefaults.standard.array(forKey: "RouteDetails") as? [Data] {
            let encoder = JSONEncoder()
            do {
                let updatedData = try encoder.encode(updatedTranslation)
                savedData[index] = updatedData // Update the specific index
                UserDefaults.standard.set(savedData, forKey: "RouteDetails")
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
            }
        }
        showAlert(title: "Updated", message: "Your Route Has Been Updated Successfully.")
    }
    
    func saveCreateSaleDetail(_ order: Routes) {
        var orders = UserDefaults.standard.object(forKey: "RouteDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(order)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "RouteDetails")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Route Details has been Added Successfully.")
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        saveRouteData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
