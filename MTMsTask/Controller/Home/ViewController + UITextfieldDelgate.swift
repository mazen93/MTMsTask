//
//  ViewController + UITextfieldDeelgate.swift
//  MTMsTask
//
//  Created by host on 14/01/2022.
//

import Foundation
import UIKit
extension ViewController:UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        configureLocationInputView()
//        self.searchView.isHidden = false
       performSegue(withIdentifier: "go", sender: self)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
//
//    //    if textField.text?.count ?? 0 > 0{
//            textfieldTag = textField.tag
//            configureLocationInputView()
//            self.searchView.isHidden = false
//            callPlacesAPI(text: textField.text ?? "")
////        }else{
////            self.searchView.isHidden = false
////        }
//
   }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        autoCompleteTableView?.isHidden = true
//    }
    
}
