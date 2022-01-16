//
//  ViewController + UITableViewDelegate.swift
//  MTMsTask
//
//  Created by host on 14/01/2022.
//

import Foundation
import UIKit
//MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompletePlacesData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        if highLightTypeTextedEnabled!{
            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            cell?.textLabel?.attributedText = NSAttributedString(string: autoCompletePlacesData[indexPath.row] as String, attributes: myAttribute)

           // cell?.textLabel?.attributedText = showHighlightedTypedText(aStr: autoCompletePlacesData[indexPath.row] as NSString)
        }else{
            cell?.textLabel?.font = autoCompleteTextFont
            cell?.textLabel?.textColor = autoCompleteTextColor
            cell?.textLabel?.text = autoCompletePlacesData[indexPath.row]
            
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let selectedText = cell?.textLabel?.text {
           // self.text = selectedText
            self.resignFirstResponder()
            selectedPlace!(selectedText, indexPath)
        }
        
        DispatchQueue.main.async {
            //tableView.isHidden = self.hidesWhenSelected

            //tableView.isHidden = true
            self.searchView.isHidden = true
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
