//
//  HistoryViewController.swift
//  BusStand Hub
//
//  Created by Maaz on 27/11/2024.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var CreateBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!  // Add this outlet for the label

    var currency = String()
    var Booking_Detail: [Booking] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientToButtonThree(view: MianView)
        applyGradientToButtonThree(view: CreateBtn)
        addDropShadowButtonOne(to : CreateBtn)
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"
        
        TableView.dataSource = self
        TableView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       

        if let savedData = UserDefaults.standard.array(forKey: "BookingDetails") as? [Data] {
            let decoder = JSONDecoder()
            Booking_Detail = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(Booking.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        noDataLabel.text = "There is no data available" // Set the message
        // Show or hide the table view and label based on data availability
               if Booking_Detail.isEmpty {
                   TableView.isHidden = true
                   noDataLabel.isHidden = false  // Show the label when there's no data
               } else {
                   TableView.isHidden = false
                   noDataLabel.isHidden = true   // Hide the label when data is available
               }
        
        TableView.reloadData()
    }
    func generatePDF() {
           let pdfFileName = NSTemporaryDirectory() + "BookingDetails.pdf"
           
           let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // Standard A4 size
           
           do {
               try renderer.writePDF(to: URL(fileURLWithPath: pdfFileName)) { context in
                   context.beginPage()
                   
                   // Title
                   let title = "Booking Details"
                   let titleAttributes: [NSAttributedString.Key: Any] = [
                       .font: UIFont.boldSystemFont(ofSize: 18)
                   ]
                   title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)
                   
                   // Table header
                   let header = "Bus Name | Passenger Name | Phone No# | User | Address | Date Of Booking | Departed Time | Start From | Destination | Fair | Discount "
                   let headerAttributes: [NSAttributedString.Key: Any] = [
                       .font: UIFont.boldSystemFont(ofSize: 14)
                   ]
                   header.draw(at: CGPoint(x: 20, y: 60), withAttributes: headerAttributes)
                   
                   // Draw data
                   var currentY = 90
                   for order in Booking_Detail {
                       let orderLine = "\(order.busName) | \(order.passengerName) | \(order.phoneNumber) | \(order.address) | \(order.dateofday) | \(order.departedTiming) | \(order.departedPlace) | \(order.destination) | \(order.payment) | \(order.Discount) |"
                       let lineAttributes: [NSAttributedString.Key: Any] = [
                           .font: UIFont.systemFont(ofSize: 12)
                       ]
                       orderLine.draw(at: CGPoint(x: 20, y: CGFloat(currentY)), withAttributes: lineAttributes)
                       currentY += 20
                       
                       if currentY > 750 { // Prevent content overflow
                           context.beginPage()
                           currentY = 20
                       }
                   }
               }
               
               // Share or present the PDF
               let pdfURL = URL(fileURLWithPath: pdfFileName)
               let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
               self.present(activityVC, animated: true, completion: nil)
               
           } catch {
               print("Failed to create PDF: \(error.localizedDescription)")
           }
       }
       
       func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
           return formatter.string(from: date)
       }
  
    
    @IBAction func GenteratorPDFButton(_ sender: Any) {
        generatePDF()

        
    }
    
    @IBAction func CreateBookingButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateBookingViewController") as! CreateBookingViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }


}
extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Booking_Detail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyTableViewCell
        
        let BookingData = Booking_Detail[indexPath.item]
        
        cell.passengerNameLabel.text = "Passenger: \(BookingData.passengerName)"
        cell.BusNameLabel.text = "Bus Name: \(BookingData.busName)"
        cell.PhoneNoLabel.text = "P.No#: \(BookingData.phoneNumber)"

        cell.StartfromLabel.text = "\(BookingData.departedPlace) -"
        cell.DetinationLabel.text = BookingData.destination
        cell.fairLabel.text = "Fair:\(currency) \(BookingData.payment)"
        cell.DepartedTimingLabel.text = "Departed Timing: \(BookingData.departedTiming)"
        cell.DateOfTheDayLabel.text = BookingData.dateofday
        cell.DiscountLabel.text = "\(BookingData.Discount)% Discount"


        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Booking_Detail.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try Booking_Detail.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "BookingDetails")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
