//
//  RoutesViewController.swift
//  BusStand Hub
//
//  Created by Maaz on 27/11/2024.
//

import UIKit

class RoutesViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var AddRoutesBtn: UIButton!
    
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!  // Add this outlet for the label

    var currency = String()
    var Routes_Detail: [Routes] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientToButtonThree(view: MianView)
        applyGradientToButtonThree(view: AddRoutesBtn)
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"
        
        TableView.dataSource = self
        TableView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       

        if let savedData = UserDefaults.standard.array(forKey: "RouteDetails") as? [Data] {
            let decoder = JSONDecoder()
            Routes_Detail = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(Routes.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "There is no data available" // Set the message
        // Show or hide the table view and label based on data availability
               if Routes_Detail.isEmpty {
                   TableView.isHidden = true
                   noDataLabel.isHidden = false  // Show the label when there's no data
               } else {
                   TableView.isHidden = false
                   noDataLabel.isHidden = true   // Hide the label when data is available
               }
        print(Routes_Detail)  // Check if data is loaded
        TableView.reloadData()
    }

  
    
    @IBAction func AddTheRoutesButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddRoutesViewController") as! AddRoutesViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }


}
extension RoutesViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Routes_Detail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RoutesTableViewCell
        
        let RoutesData = Routes_Detail[indexPath.item]
        cell.BusNameLabel.text = RoutesData.bus
        cell.StartfromLabel.text = "\(RoutesData.startFrom) -"
        cell.DetinationLabel.text = RoutesData.destination
        cell.fairLabel.text = "Fair:\(currency) \(RoutesData.routeFair)"
        cell.DepartedTimingLabel.text = "Departed Timing: \(RoutesData.departingTiming)"

        
        cell.SellButton.tag = indexPath.row // Set tag to identify the row
        cell.SellButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        
        cell.updateButton.tag = indexPath.row // Set tag to identify the row
        cell.updateButton.addTarget(self, action: #selector(buttonTappedUpdate(_:)), for: .touchUpInside)
        
        // Set up delete action for the DeleteButton
         cell.deleteAction = { [weak self] in
         self?.confirmDelete(at: indexPath)
         }
        return cell
    }
    @objc func buttonTapped(_ sender: UIButton) {
        
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let userData = Routes_Detail[sender.tag]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateBookingViewController") as! CreateBookingViewController
        newViewController.selectedRoutesDetail = userData
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
 
      
    }
    @objc func buttonTappedUpdate(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let routeData = Routes_Detail[sender.tag]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddRoutesViewController") as! AddRoutesViewController
        newViewController.selectedRouteDetail = routeData
        newViewController.selectedIndex = sender.tag // Pass the index for updating
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    func confirmDelete(at indexPath: IndexPath) {
        // Show alert to confirm deletion
        let alert = UIAlertController(title: "Delete Product", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove product from array
            self.Routes_Detail.remove(at: indexPath.item)
            
            // Update UserDefaults with new product array
            let encoder = JSONEncoder()
            let savedData = self.Routes_Detail.compactMap { try? encoder.encode($0) }
            UserDefaults.standard.set(savedData, forKey: "BusesDetails")
            
            // Reload collection view
            self.TableView.reloadData()
            
            // Update visibility of noDataLabel
            self.noDataLabel.isHidden = !self.Routes_Detail.isEmpty
        }))
        
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    }
