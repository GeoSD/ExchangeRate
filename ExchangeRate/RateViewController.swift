//
//  RateViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    
    var date = ""
    var rateForDate = [String]()
    var usdRate = ""
    var eurRate = ""

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var eurRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = date
        print(rateForDate)
        usdRateLabel.text = rateForDate[0]
        eurRateLabel.text = rateForDate[1]

    }
}
