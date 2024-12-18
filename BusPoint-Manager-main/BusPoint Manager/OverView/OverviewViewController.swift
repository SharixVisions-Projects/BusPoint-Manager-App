//
//  OverviewViewController.swift
//  ShareWise Ease
//
//  Created by Maaz on 16/10/2024.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var RoutesLael: UILabel!
    @IBOutlet weak var BusLabel: UILabel!
    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var detailMianView2: UIView!
    @IBOutlet weak var detailMianView1: UIView!
    
    @IBOutlet weak var MainDetailView: UIView!
    @IBOutlet weak var todaySalesAmount: UILabel!
    @IBOutlet weak var totalSalesAmount: UILabel!
    
    @IBOutlet weak var BusesCountLabel: UILabel!
    @IBOutlet weak var RouteCountLabel: UILabel!
    @IBOutlet weak var ManualBookingCountLabel: UILabel!
    @IBOutlet weak var SaleRepairSegment: UISegmentedControl!
    @IBOutlet weak var TableView: UITableView!

    
//    var filteredOrders: [AllSales] = [] // This will contain the filtered orders
//    var lineChartView: LineChartView!
    
    var currency = String()
    var noDataLabel: UILabel!
    
    var Booking_Detail: [Booking] = []
    var filteredOrders: [Booking] = [] // This will contain the filtered orders
    
    var Bus_Detail: [Bus] = []
    var filteredBus: [Bus] = []
    
    var Route_Detail: [Routes] = []
    var filteredRoute: [Routes] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.dataSource = self
        TableView.delegate = self
        
        applyGradientToButtonThree(view: MianView)
        
        addDropShadow(to: detailMianView2)
        addDropShadow(to: detailMianView1)
        addDropShadow(to: MainDetailView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"
        
        // Load data from UserDefaults of Buses
        if let savedData = UserDefaults.standard.array(forKey: "BusesDetails") as? [Data] {
            let decoder = JSONDecoder()
            Bus_Detail = savedData.compactMap { data in
                do {
                    let bus = try decoder.decode(Bus.self, from: data)
                    return bus
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        BusesCountLabel.text = "\(Bus_Detail.count)"
        // Load data from UserDefaults of Routes
        if let savedData = UserDefaults.standard.array(forKey: "RouteDetails") as? [Data] {
            let decoder = JSONDecoder()
            Route_Detail = savedData.compactMap { data in
                do {
                    let Route = try decoder.decode(Routes.self, from: data)
                    return Route
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        RouteCountLabel.text = "\(Route_Detail.count)"
        // Load data from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "BookingDetails") as? [Data] {
            let decoder = JSONDecoder()
            Booking_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(Booking.self, from: data)
                    return order
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        ManualBookingCountLabel.text = "\(Booking_Detail.count)"
        // Calculate sales amounts
        calculateSalesAmounts()
        // Apply initial filter (all orders by default)
        filterOrdersBySegment()
    }
    @IBAction func SRsegment(_ sender: UISegmentedControl) {
        // Filter the orders when the segment changes
        filterOrdersBySegment()
    }
   
    func filterOrdersBySegment() {
        let selectedSegment = SaleRepairSegment.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            filteredBus = Bus_Detail
        case 1:
            filteredRoute = Route_Detail
        case 2:
            filteredOrders = Booking_Detail
        default:
            break
        }
        
        // Reload the table view with filtered data
        TableView.reloadData()
    }

 
    
  private  func addBottomCurveforView(view: UIView, curveHeight: CGFloat = 80) {
          // Define the size of the view
          let viewBounds = view.bounds
          
          // Create a bezier path with a curved bottom
          let path = UIBezierPath()
          path.move(to: CGPoint(x: 0, y: 0))
          path.addLine(to: CGPoint(x: viewBounds.width, y: 0))
          path.addLine(to: CGPoint(x: viewBounds.width, y: viewBounds.height - curveHeight)) // Adjust height for curve
          path.addQuadCurve(to: CGPoint(x: 0, y: viewBounds.height - curveHeight), controlPoint: CGPoint(x: viewBounds.width / 2, y: viewBounds.height)) // Control point for curve
          path.close()
          
          // Create a shape layer mask
          let maskLayer = CAShapeLayer()
          maskLayer.path = path.cgPath
          
          // Apply the mask to the view
          view.layer.mask = maskLayer
      }

    func calculateSalesAmounts() {
        let today = Date()
        let calendar = Calendar.current
        
        // Format today's date to compare with order dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let todayString = dateFormatter.string(from: today)
        
        var totalSales: Double = 0.0
        var todaySales: Double = 0.0
        
        // Loop through all orders to calculate the total sales and today's sales
        for order in Booking_Detail {
            // Convert amount to Double (assuming it's a valid number)
            if let amount = Double(order.payment) {
                // Add to total sales
                totalSales += amount
                
                // Convert order.dateofday (String) to Date
                if let orderDate = dateFormatter.date(from: order.dateofday) {
                    // Check if the order date is today
                    let orderDateString = dateFormatter.string(from: orderDate)
                    if orderDateString == todayString {
                        todaySales += amount
                    }
                } else {
                    print("Invalid date format in order.dateofday: \(order.dateofday)")
                }
            }
        }
        
        // Update labels with the calculated values
        totalSalesAmount.text = String(format: "\(currency)%.2f", totalSales)
        todaySalesAmount.text = String(format: "\(currency)%.2f", todaySales)
    }

    
    @IBAction func ViewAllSalesbutton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewSalesViewController") as! ViewSalesViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func CurrenctButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedSegment = SaleRepairSegment.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            return filteredBus.count
        case 1:
            return filteredRoute.count
        case 2:
            return filteredOrders.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as! OverviewTableViewCell
        let selectedSegment = SaleRepairSegment.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            let busData = filteredBus[indexPath.row]
            cell.productNameLbl?.text = busData.name
            cell.salesTypeLabel?.text = ""
            cell.Imagees.image = UIImage(named: "bus_daimler")
            //cell.dateLbl.text = busData.dayeofday
            cell.dateLbl.isHidden = true
        case 1:
            let routeData = filteredRoute[indexPath.row]
            cell.productNameLbl?.text = "Journey Start From: \(routeData.startFrom)"
            cell.salesTypeLabel?.text = "Destination: \(routeData.destination)"
           cell.Imagees.image = UIImage(named: "ROUTE")
            cell.dateLbl.isHidden = true
            
        case 2:
            let orderData = filteredOrders[indexPath.row]
            cell.productNameLbl?.text = orderData.passengerName
            cell.salesTypeLabel?.text = orderData.busName
            cell.Imagees.image = UIImage(named: "bb")
            cell.dateLbl.text = orderData.dateofday
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

