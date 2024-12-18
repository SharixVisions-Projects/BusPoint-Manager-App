//
//  OrderDetailViewController.swift
//  POS
//
//  Created by Maaz on 11/10/2024.
//

import UIKit
import PDFKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var fairLbl: UILabel!
    @IBOutlet weak var DestinatioLabel: UILabel!
    @IBOutlet weak var JourneyStartFromLabel: UILabel!
    @IBOutlet weak var departedTimeLabel: UILabel!

    @IBOutlet weak var passengerPhoneNoLbl: UILabel!
    @IBOutlet weak var BusNameLbl: UILabel!
    @IBOutlet weak var dateOfbookingLbl: UILabel!
    @IBOutlet weak var PassengerNameLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var ShareBtn: UIButton!


    
    var selectedOrderDetail: Booking?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"
        applyGradientToButtonThree(view: MianView)
        applyGradientToButtonThree(view: ShareBtn)

        addDropShadow(to: pdfView)
        addDropShadowButtonOne(to : ShareBtn)

        if let orderDetail = selectedOrderDetail {
            // Assigning values as per your existing logic
            orderNoLabel.text = orderDetail.id
            PassengerNameLabel.text = orderDetail.passengerName
            dateOfbookingLbl.text =  "\(orderDetail.dateofday)"

//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .medium
//            dateFormatter.timeStyle = .none
//            let dateString = dateFormatter.string(from: orderDetail.DateOfOrder)
//            dateOfOrderLbl.text = dateString
            
            BusNameLbl.text = orderDetail.busName
            passengerPhoneNoLbl.text = orderDetail.phoneNumber
            departedTimeLabel.text =  "\(orderDetail.departedTiming)"
            JourneyStartFromLabel.text = "\(orderDetail.departedPlace)"
            DestinatioLabel.text = "\(orderDetail.destination)"
            fairLbl.text = "\(currency) \( orderDetail.payment)"
            discountLabel.text = "\( orderDetail.Discount)%"

            
          
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"

    }

//    func showPopViewWithAnimation() {
//        popView.isHidden = false // Ensure the view is visible
//        
//        // Initial state before animation
//        popView.alpha = 0.0 // Start fully transparent
//        popView.transform = CGAffineTransform(translationX: 0, y: 100) // Start slightly below its final position
//        
//        // Animation to fade in and slide up
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
//            self.popView.alpha = 1.0 // Fade in
//            self.popView.transform = CGAffineTransform.identity // Slide up to its original position
//        }, completion: nil)
//    }
    
//    func hidePopViewWithAnimation() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
//            self.popView.alpha = 0.0 // Fade out
//            self.popView.transform = CGAffineTransform(translationX: 0, y: 100) // Slide down
//        }, completion: { _ in
//            self.popView.isHidden = true // Hide after animation completes
//        })
//    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

  
    @IBAction func ShareButton(_ sender: Any) {
        // Convert pdfView to an image
        guard let image = pdfView.asImage() else {
            print("Failed to convert pdfView to image")
            return
        }
        
        // Present a share sheet with the image
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // For iPad compatibility
        present(activityVC, animated: true)
    }

    
    
    @IBAction func PdfGenerateButton(_ sender: Any) {
        let pdfData = createPDF(from: pdfView)
        savePdf(data: pdfData)
    }

    // Function to show an alert
       func showAlert(_ message: String) {
           let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    // Function to create PDF from the view
    func createPDF(from view: UIView) -> Data {
        let pdfPageFrame = view.bounds
        let pdfData = NSMutableData()
        
        // Create the PDF context
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        
        // Render the view into the PDF context
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return Data() }
        view.layer.render(in: pdfContext)
        
        // Close the PDF context
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
    
    // Function to save the PDF data to the device
    func savePdf(data: Data) {
        // Specify the file path and name
        let fileName = "OrderDetail.pdf"
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            // Write the PDF data to the file
            do {
                try data.write(to: fileURL)
                print("PDF saved at: \(fileURL)")
                
                // Present sharing options for the saved PDF
                let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                present(activityVC, animated: true, completion: nil)
                
            } catch {
                print("Could not save PDF file: \(error.localizedDescription)")
            }
        }
    }
}
extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}
