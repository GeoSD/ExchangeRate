//
//  RateViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var eurRateLabel: UILabel!
    
    let rateService = RateService()
    var date = ""
    
    var rates = [String]() {
        didSet {
            usdRateLabel.text = rates[0]
            eurRateLabel.text = rates[1]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = date
        
        rateService.getRateForDate(date) { (rates) in
            self.rates = rates
        }
    }
    
}
