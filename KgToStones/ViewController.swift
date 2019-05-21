//
//  ViewController.swift
//  KgToStones
//
//  Created by Ana Victoria Frias on 5/18/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, convertDelegate {
//    IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
//    Variables
    var convertws = ConvertWS()
    override func viewDidLoad() {
        super.viewDidLoad()
        convertws.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func convert(_ sender: Any) {
        inputText.resignFirstResponder()
        guard inputText.text == "" else {
            if let valueInteger = Int(inputText.text!) {
                 LoadingOverlay.shared.showOverlay(view: self.view)
                convertws.convertKilosToStones(value: valueInteger)
            }
            return
        }
        
    }
    
    func didSuccessGetResult(result: Double) {
        print(result)
        LoadingOverlay.shared.hideOverlayView()
//        Convert double to two digits tho
        let doubleStr = String(format: "%.2f", result)
        resultLabel.text = doubleStr
        
    }
    func didFailGetResult(error: String) {
        
        let alert = UIAlertController(title: "Oops!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            LoadingOverlay.shared.hideOverlayView()
//            BACKUP PLAN
            var result = Double()
            if let number = Double(self.inputText.text!) {
                result = number * 0.157473
                let doubleStr = String(format: "%.2f", result)
                self.resultLabel.text = doubleStr
                
            }
            
        })
        
    }
}

