//
//  CreateBookingViewController.swift
//  BusStand Hub
//
//  Created by Maaz on 26/11/2024.
//

import UIKit

class CreateBookingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var MianView: UIView!
    
    @IBOutlet weak var BusTF: DropDown!
    @IBOutlet weak var PassengerNameTF: UITextField!
    @IBOutlet weak var PassengerPhoneNoTF: UITextField!
    @IBOutlet weak var PassengerAddressTF: UITextField!
    @IBOutlet weak var DepartedTimingTF: UIDatePicker!
    @IBOutlet weak var DateofBooking: UIDatePicker!
    @IBOutlet weak var DepartedPlaceTF: UITextField!
    @IBOutlet weak var DestinationTF: UITextField!
    @IBOutlet weak var FairTF: UITextField!
    @IBOutlet weak var DiscountTF: UITextField!
    @IBOutlet weak var CreateButton: UIButton!

    var Bus_Detail: [Bus] = [] // Array of User model objects
   // var selectedOrderDetail: Products?
    private var numberPicker = UIPickerView()
    private let numbers = Array(1...1000) // Array of numbers from 1 to 100
    private var activeTextField: UITextField?
    
    var selectedOrderDetail: Bus?
    var selectedRoutesDetail: Routes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userOrder = selectedOrderDetail {
            BusTF.text = userOrder.name
            FairTF.text = userOrder.routeFair
            DepartedPlaceTF.text = userOrder.currentPlace
            DestinationTF.text = userOrder.destination


        }
        if let Routes = selectedRoutesDetail {
            BusTF.text = Routes.bus
            FairTF.text = Routes.routeFair
            DepartedPlaceTF.text = Routes.startFrom
            DestinationTF.text = Routes.destination


        }
        applyGradientToButtonThree(view: MianView)
        applyGradientToButtonThree(view: CreateButton)

        setupNumberPicker(for: DiscountTF)

        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        BusTF.delegate = self
        
        // Set delegates
        DiscountTF.delegate = self
        FairTF.delegate = self
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
    func applyDiscount() {
          guard let amountText = FairTF.text,
                let originalAmount = Double(amountText),
                let discountText = DiscountTF.text,
                let discountValue = Double(discountText) else {
              // Handle invalid input
              showAlert(title: "Invalid Input", message: "Please enter valid numbers in Amount and Discount fields.")
              return
          }

          // Calculate the discounted amount
          let discount = (originalAmount * discountValue) / 100
          let discountedAmount = originalAmount - discount

          // Update the AmountTF with discounted value
        FairTF.text = String(format: "%.2f", discountedAmount)

          // Optional: Visual feedback for successful discount application
          DiscountTF.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        FairTF.backgroundColor = .systemGreen.withAlphaComponent(0.2)

          // Reset background colors after a delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
           
          }
      }

      // Optional: Reset discounted amount when DiscountTF is cleared
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          if textField == DiscountTF, string.isEmpty {
              // Reset to original amount when discount field is cleared
              if let originalAmount = Double(FairTF.text ?? "0") {
                  FairTF.text = String(format: "%.2f", originalAmount)
              }
          }
          return true
      }
    func setupNumberPicker(for textField: UITextField) {
        // Set up the UIPickerView
        numberPicker.delegate = self
        numberPicker.dataSource = self
        
        // Assign the picker to the text field's input view
        textField.inputView = numberPicker
        
        // Add toolbar with "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
        // Set text field delegate and track the active text field
        textField.delegate = self
    }
    @objc func donePressed() {
        // Get the selected number from the picker and set it to the active text field
        if let textField = activeTextField {
            let selectedRow = numberPicker.selectedRow(inComponent: 0)
            textField.text = "\(numbers[selectedRow])"
            textField.resignFirstResponder()
        }
    }
    
    // UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
//        // Custom logic for specific fields
//        if textField == NowAmountTF {
//            showAlert(title: "Notice", message: "Please Add Amount after implementing the installments charges")
//            textField.resignFirstResponder() // Prevents editing
//        }
    }
    // Reset background color for AmountTF and DiscountTF when DiscountTF is cleared
    func textField2(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == DiscountTF, string.isEmpty {
            // Reset AmountTF when DiscountTF is cleared
            if let originalAmount = Double(FairTF.text ?? "0") {
                FairTF.text = String(format: "%.2f", originalAmount)
            }
        }
        return true
    }
    // MARK: - UITextField Delegate
    
  
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
        
        if textField == DiscountTF {
            applyDiscount()
        }
    }
    
    // MARK: - UIPickerView Data Source and Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
    func clearTextFields() {
        BusTF.text = ""
        PassengerNameTF.text = ""
        PassengerPhoneNoTF.text = ""
        PassengerAddressTF.text = ""
        DestinationTF.text = ""
        FairTF.text = ""
        DiscountTF.text = ""

    }
    
    func saveBookingData(_ sender: Any) {
        // Check if all mandatory fields are filled
        guard let bus = BusTF.text, !bus.isEmpty,
              let passengerName = PassengerNameTF.text, !passengerName.isEmpty,
              let passengerNo = PassengerPhoneNoTF.text, !passengerNo.isEmpty,
              let passengerAddress = PassengerAddressTF.text, !passengerAddress.isEmpty,
              let destination = DestinationTF.text, !destination.isEmpty,
              let DepartedPlace = DepartedPlaceTF.text, !DepartedPlace.isEmpty,
              
              let fair = FairTF.text, !fair.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        // Get the values from UIDatePickers
        let departedtiming = DepartedTimingTF.date
        let DateofBooking = DateofBooking.date

        // Convert dates to String
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a" // Format for departed timing
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Format for booking date
        
        let busstarttimingString = timeFormatter.string(from: departedtiming)
        let bookingDateString = dateFormatter.string(from: DateofBooking)
        
        let discounts = DiscountTF.text ?? nil

        // Generate random character for order number
        let randomCharacter = generateOrderNumber()
      
        // Create new booking detail safely
        let newBookingDetail = Booking(
            id: "\(randomCharacter)",
            busName: bus,
            passengerName: passengerName,
            phoneNumber: passengerNo,
            address: passengerAddress,
            dateofday: bookingDateString, // Convert Date to String
            departedTiming: busstarttimingString, // Convert Date to String
            departedPlace: DepartedPlace,
            destination: destination,
            payment: fair,
            Discount: discounts ?? "N/A"
        )
        
        // Save the booking detail
        saveOrderDetail(newBookingDetail)
    }


    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Corrected year format
        return dateFormatter.date(from: dateString)
    }
    
    func saveOrderDetail(_ order: Booking) {
        var orders = UserDefaults.standard.object(forKey: "BookingDetails") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(order)
            orders.append(data)
            UserDefaults.standard.set(orders, forKey: "BookingDetails")
            clearTextFields()
           
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Booking has been saved successfully made.")
    }
    @IBAction func SaveButton(_ sender: Any) {
        saveBookingData(sender)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
