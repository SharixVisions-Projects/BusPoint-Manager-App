//
//  WelcomeThreeViewController.swift
//  NameSpectrum Hub
//
//  Created by Maaz on 03/10/2024.
//

import UIKit

class WelcomeThreeViewController: UIViewController {
    
    @IBOutlet weak var VurveView: UIView!
    @IBOutlet weak var StartBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBottomCurveforView(view: VurveView)
        applyGradientToButtonThree(view: VurveView)
        applyGradientToButtonThree(view: StartBtn)


    }
    
    @IBAction func startButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    func applyGradientToButtonThree(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                                   
                UIColor(hex: "#710594").cgColor,
                UIColor(hex: "#8b1fc3").cgColor,
                UIColor(hex: "#9e31e4").cgColor, UIColor(hex: "#df87ff").cgColor
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

    
}
