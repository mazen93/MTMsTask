//
//  AutoCompleteTextField.swift
//  MTMsTask
//
//  Created by host on 13/01/2022.
//

import Foundation
import UIKit

public class AutoCompleteTextField:UITextField {
    /// Manages the instance of tableview
    private var autoCompleteTableView:UITableView?
    /// Holds the collection of attributed strings
    private lazy var attributedAutoCompleteStrings = [NSAttributedString]()
    /// Handles user selection action on autocomplete table view
    public var onSelect:(String, NSIndexPath)->() = {_,_ in}
    /// Handles textfield's textchanged
    public var onTextChange:(String)->() = {_ in}
    
    /// Font for the text suggestions
    public var autoCompleteTextFont = UIFont.systemFont(ofSize: 12)
    /// Color of the text suggestions
    public var autoCompleteTextColor = UIColor.black
    /// Used to set the height of cell for each suggestions
    public var autoCompleteCellHeight:CGFloat = 44.0
    /// The maximum visible suggestion
    public var maximumAutoCompleteCount = 3
    /// Used to set your own preferred separator inset
    public var autoCompleteSeparatorInset = UIEdgeInsets.zero
    /// Shows autocomplete text with formatting
    public var enableAttributedText = false
    /// User Defined Attributes
    public var autoCompleteAttributes:[String:AnyObject]?
    /// Hides autocomplete tableview after selecting a suggestion
    public var hidesWhenSelected = true
    /// Hides autocomplete tableview when the textfield is empty
    public var hidesWhenEmpty:Bool?{
        didSet{
            assert(hidesWhenEmpty != nil, "hideWhenEmpty cannot be set to nil")
            autoCompleteTableView?.isHidden = hidesWhenEmpty!
        }
    }
    /// The table view height
    public var autoCompleteTableHeight:CGFloat?{
        didSet{
            redrawTable()
        }
    }
    /// The strings to be shown on as suggestions, setting the value of this automatically reload the tableview
    public var autoCompleteStrings:[String]?{
        didSet{ reload() }
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupAutocompleteTable(view: superview!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        setupAutocompleteTable(view: superview!)
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        commonInit()
        setupAutocompleteTable(view: newSuperview!)
    }
    
    private func commonInit(){
        hidesWhenEmpty = true
        autoCompleteAttributes = [NSAttributedString.Key.foregroundColor.rawValue:UIColor.black]
        autoCompleteAttributes![NSAttributedString.Key.font.rawValue] = UIFont.boldSystemFont(ofSize: 12)
        self.clearButtonMode = .always
        self.addTarget(self, action: "textFieldDidChange", for: .editingChanged)
        self.addTarget(self, action: "textFieldDidEndEditing", for: .editingDidEnd)
    }
    
    private func setupAutocompleteTable(view:UIView){
        let screenSize = UIScreen.main.bounds.size
        let tableView = UITableView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height, width: screenSize.width - (self.frame.origin.x * 2), height: 30.0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = autoCompleteCellHeight
        tableView.isHidden = hidesWhenEmpty ?? true
        view.addSubview(tableView)
        autoCompleteTableView = tableView
        
        autoCompleteTableHeight = 100.0
    }
    
    private func redrawTable(){
        if let autoCompleteTableView = autoCompleteTableView, let autoCompleteTableHeight = autoCompleteTableHeight {
            var newFrame = autoCompleteTableView.frame
            newFrame.size.height = autoCompleteTableHeight
            autoCompleteTableView.frame = newFrame
        }
    }
    
    //MARK: - Private Methods
    private func reload(){
        if enableAttributedText{
            let attrs = [NSAttributedString.Key.foregroundColor:autoCompleteTextColor, NSAttributedString.Key.font:autoCompleteTextFont]
    
            if attributedAutoCompleteStrings.count > 0 {
                attributedAutoCompleteStrings.removeAll()
                
            }
            
//            if let autoCompleteStrings = autoCompleteStrings, let autoCompleteAttributes = autoCompleteAttributes {
//                for i in 0..<autoCompleteStrings.count{
//                    let str = autoCompleteStrings[i] as NSString
//                    let range = str.range(of: text!, options: .caseInsensitive)
//                    let attString = NSMutableAttributedString(string: autoCompleteStrings[i], attributes: attrs)
//                    attString.addAttributes(autoCompleteAttributes, range: range)
//                    attributedAutoCompleteStrings.append(attString)
//                }
//            }
        }
        autoCompleteTableView?.reloadData()
    }
    
    func textFieldDidChange(){
        guard let _ = text else {
            return
        }
        
        onTextChange(text!)
        if text!.isEmpty{ autoCompleteStrings = nil }
        DispatchQueue.main.async {
            self.autoCompleteTableView?.isHidden =  self.hidesWhenEmpty! ? self.text!.isEmpty : false
        }
    }
    
    func textFieldDidEndEditing() {
        autoCompleteTableView?.isHidden = true
    }
}

//MARK: - UITableViewDataSource - UITableViewDelegate
extension AutoCompleteTextField: UITableViewDataSource, UITableViewDelegate {
  
    
  
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteStrings != nil ? (autoCompleteStrings!.count > maximumAutoCompleteCount ? maximumAutoCompleteCount : autoCompleteStrings!.count) : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if enableAttributedText{
            cell?.textLabel?.attributedText = attributedAutoCompleteStrings[indexPath.row]
        }
        else{
            cell?.textLabel?.font = autoCompleteTextFont
            cell?.textLabel?.textColor = autoCompleteTextColor
            cell?.textLabel?.text = autoCompleteStrings![indexPath.row]
        }
        
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        if let selectedText = cell?.textLabel?.text {
            self.text = selectedText
            onSelect(selectedText, indexPath)
        }
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            tableView.hidden = self.hidesWhenSelected
//        })
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       //if cell.respondsToSelector("setSeparatorInset:"){
            cell.separatorInset = autoCompleteSeparatorInset
           cell.layoutMargins = autoCompleteSeparatorInset
        cell.preservesSuperviewLayoutMargins = false
      //  }
//        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:"){
//            cell.preservesSuperviewLayoutMargins = false
//        }
//
//
//
//        if cell.respondsToSelector("setLayoutMargins:"){
//            cell.layoutMargins = autoCompleteSeparatorInset
//        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
}
