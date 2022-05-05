//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var exchangeRatesAbel: UILabel?
    @IBOutlet weak var currencyScroll: UIPickerView?
    @IBOutlet weak var currencyLabel: UILabel?
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyScroll?.dataSource = self
        currencyScroll?.delegate = self
        
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
    
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdateManager(price: String, currency: String) {
        DispatchQueue.main.async { [self] in
            exchangeRatesAbel?.text = price
            currencyLabel?.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

