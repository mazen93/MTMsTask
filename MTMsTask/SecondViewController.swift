//
//  SecondViewController.swift
//  MTMsTask
//
//  Created by host on 13/01/2022.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var aTextField: AJAutocompletePlaceTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        aTextField.highLightTypeTextedEnabled = true
        
        //For Getting selected place and indexPath
        aTextField.selectedPlace = { place , indexPath in
            print("SELECTED PLACE : \(place)")
            print("INDEXPATH : \(indexPath)")
            
            
        }
    }
   
    


}
