//
//  ViewSalesViewController.swift
//  ShareWise Ease
//
//  Created by Maaz on 17/10/2024.
//
import UIKit
import PDFKit

class ViewSalesViewController: UIViewController {

    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var FromDatePicker: UIDatePicker!
    @IBOutlet weak var ToDatePicker: UIDatePicker!
    
    var currency = String()
    var Booking_Detail: [Booking] = []
    var filteredOrderDetails: [Booking] = []  // Filtered data to display in the table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        applyGradientToButtonThree(view: MianView)

        
        // Add targets for the date pickers
        FromDatePicker.addTarget(self, action: #selector(fromDatePickerChanged(_:)), for: .valueChanged)
        ToDatePicker.addTarget(self, action: #selector(toDatePickerChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedData = UserDefaults.standard.array(forKey: "BookingDetails") as? [Data] {
            let decoder = JSONDecoder()
            Booking_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(Booking.self, from: data)
                    print("Decoded Order: \(order)") // Debugging
                    return order
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        filteredOrderDetails = Booking_Detail
        TableView.reloadData()
    }

    
    @objc func fromDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    @objc func toDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    func filterTransactions() {
        let fromDate = FromDatePicker.date
        let toDate = ToDatePicker.date
        
        // Configure DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        // Debugging logs
        print("From Date: \(fromDate), To Date: \(toDate)")

        filteredOrderDetails = Booking_Detail.filter { order in
            if let orderDate = dateFormatter.date(from: order.dateofday) {
                print("Order Date: \(orderDate)") // Debugging
                return orderDate >= fromDate && orderDate <= toDate
            }
            print("Failed to parse date: \(order.dateofday)")
            return false
        }

        print("Filtered Results Count: \(filteredOrderDetails.count)")
        TableView.reloadData()
    }




    
    @IBAction func PdfGenerateButton(_ sender: Any) {
        generatePDF()
    }
    
    func generatePDF() {
        // Create a PDF document
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        let pdfData = pdfRenderer.pdfData { (context) in
            context.beginPage()

            var yOffset: CGFloat = 20.0
            let dataToExport = filteredOrderDetails.isEmpty ? Booking_Detail : filteredOrderDetails  // Use filtered data if available

            for order in dataToExport {
                let Busname = "Bus Name: \(order.busName)"
                let passengerNameLbl = "Passenger Name: \(order.passengerName)"
                let passengerNoLbl = "Passenger No: \(order.phoneNumber)"
                let passengerAddressLbl = "Passenger Address: \(order.address)"
                let dateLabel = "Date of booking: \(order.dateofday)"
                let departedtimeLbl = "Departed Time: \(order.departedTiming)"
                let departedplaceLbl = "Departed Place: \(order.departedPlace)"
                let destinationLbl = "Destination: \(order.destination)"
                let paymentLbl = "Payment: \(order.payment)"
                let discountLbl = "Discount: \(order.Discount)"
                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd-MM-yyyy"
//                let orderDate = "Date: \(dateFormatter.string(from: order.DateOfOrder))"
                
                // Draw the text into the PDF
                let BusnameRect = CGRect(x: 20, y: yOffset, width: 300, height: 20)
                Busname.draw(in: BusnameRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let passengerNameLblRect = CGRect(x: 20, y: yOffset + 20, width: 300, height: 20)
                passengerNameLbl.draw(in: passengerNameLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let passengerNoLblRect = CGRect(x: 20, y: yOffset + 40, width: 300, height: 20)
                passengerNoLbl.draw(in: passengerNoLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let passengerAddressLblRect = CGRect(x: 20, y: yOffset + 60, width: 300, height: 20)
                passengerAddressLbl.draw(in: passengerAddressLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let dateLabelRect = CGRect(x: 20, y: yOffset, width: 300, height: 20)
                dateLabel.draw(in: dateLabelRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let departedtimeLblRect = CGRect(x: 20, y: yOffset + 20, width: 300, height: 20)
                departedtimeLbl.draw(in: departedtimeLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let departedplaceLblRect = CGRect(x: 20, y: yOffset + 40, width: 300, height: 20)
                departedplaceLbl.draw(in: departedplaceLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let destinationLblRect = CGRect(x: 20, y: yOffset + 60, width: 300, height: 20)
                destinationLbl.draw(in: destinationLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let paymentLblRect = CGRect(x: 20, y: yOffset + 40, width: 300, height: 20)
                departedplaceLbl.draw(in: paymentLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                let discountLblRect = CGRect(x: 20, y: yOffset + 60, width: 300, height: 20)
                discountLbl.draw(in: discountLblRect, withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
                
                // Update yOffset for the next entry
                yOffset += 100.0
                
                // Start a new page if necessary
                if yOffset > 740 {
                    context.beginPage()
                    yOffset = 20.0
                }
            }
        }
        
        // Save the PDF file
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("BookingSalesReport.pdf")
        
        do {
            try pdfData.write(to: outputFileURL)
            print("PDF successfully created at \(outputFileURL)")
            
            // Present the PDF for sharing
            sharePDF(outputFileURL)
            
        } catch {
            print("Could not save PDF: \(error.localizedDescription)")
        }
    }

    func sharePDF(_ fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // For iPad compatibility (avoids crashes)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension ViewSalesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrderDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewSalesCell", for: indexPath) as! ViewSalesTableViewCell
        
        let orderData = filteredOrderDetails[indexPath.row]
        cell.busnameLabel.text = "Bus Name: \(orderData.busName)"
        cell.passengerNameLbl.text = "Passenger: \(orderData.passengerName)"
        cell.departedplaceLbl.text = "\(orderData.departedPlace) -"
        cell.destinationLbl.text = orderData.destination
        cell.paymentLbl.text = "Fair:\(currency) \(orderData.payment)"
        cell.dateLabel.text = orderData.dateofday
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let BookingData = Booking_Detail[indexPath.row]
       // let id = emp_Detail[indexPath.row].id
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            newViewController.selectedOrderDetail = BookingData
           // newViewController.userID = id
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
            
             }
        
    }
}














//    func filterTransactions() {
//        let fromDate = FromDatePicker.date
//        let toDate = ToDatePicker.date
//
//        // Define the date formatter to match your date format in `DateOfOrder`
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy" // Adjust to match the format in your Booking model
//
//        // Filter the original array based on the selected date range
//        filteredOrderDetails = Booking_Detail.filter { order in
//            if let orderDate = dateFormatter.date(from: order.dateofday) {
//                return orderDate >= fromDate && orderDate <= toDate
//            }
//            return false
//        }
//
//        // Reload the table view with the filtered data
//        TableView.reloadData()
//    }
