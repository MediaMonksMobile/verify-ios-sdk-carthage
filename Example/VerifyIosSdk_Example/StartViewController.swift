//
//  StartScreenViewController.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 24/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit

class StartViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, PageIndexable {
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    weak var parentPageViewController : VerifyPageViewController!
    
    var index: Int {
        get { return 0 }
    }
    
    var currentCountry = Country.UNITED_KINGDOM
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(parent: VerifyPageViewController) {
        self.init(nibName: "StartViewController", bundle: nil)
        parentPageViewController = parent

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.backgroundColor = Colors.nexmoDarkBlue
        countryField.inputView = countryPickerView
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (phoneNumberField.isFirstResponder() && (event?.allTouches()?.first)?.view != phoneNumberField) {
            phoneNumberField.resignFirstResponder()
            return
        }
        
        if (countryField.isFirstResponder() && (event?.allTouches()?.first)?.view != countryField) {
            countryField.resignFirstResponder()
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginVerification(sender: UIButton) {
        print("beginVerification")
        
        if (countryField.isFirstResponder()) {
            countryField.resignFirstResponder()
        }
        
        if (phoneNumberField.isFirstResponder()) {
            phoneNumberField.resignFirstResponder()
        }
        
        parentPageViewController.beginVerification()
    }
    
    // Mark: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Country.countries.count
    }
    
    // Mark: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Country.countries[row].country, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCountry = Country.countries[row]
        countryField.text = describeCountry(currentCountry)
    }
    
    func describeCountry(country: Country) -> String {
        if (country.intPrefix.count > 0) {
            return "\(country.countryCode) (+\(country.intPrefix[0]))"
        }
        
        return country.countryCode
    }
}