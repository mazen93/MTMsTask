//
//  UserPopup + tableviewDelegate.swift
//  MTMsTask
//
//  Created by host on 16/01/2022.
//

import Foundation
import UIKit
//MARK: - UITableViewDataSource & UITableViewDelegate
extension UserInputPopup: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompletePlacesData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        cell?.textLabel?.font = autoCompleteTextFont
        cell?.textLabel?.textColor = autoCompleteTextColor
        cell?.textLabel?.text = autoCompletePlacesData[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let selectedText = cell?.textLabel?.text {
            print("select item")
            self.resignFirstResponder()
            selectedPlace!(selectedText, indexPath)
        }

    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)){
            cell.separatorInset = autoCompleteSeparatorInset
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)){
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)){
            cell.layoutMargins = autoCompleteSeparatorInset
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
}

extension UserInputPopup:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
    func textFieldDidEndEditing(_ textField: UITextField) {
  
        autoCompleteTableView?.isHidden = true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        textfieldTag = textField.tag
        callPlacesAPI(text: textField.text ?? "")
        
   }
  
    

    
}
