//
//  RateViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit
import Alamofire

class RateViewController: UIViewController {
    
    var date = ""
    var rateForDate = [String]()
    var usdRate = ""
    var eurRate = ""
    
    let recordKey = "Valute"
    let dictionaryKeys = Set<String>(["CharCode", "Value"])
    
    var results: [[String: String]]?
    var currentDictionary: [String: String]?
    var currentValue: String?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var eurRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = date
        
        getRateForDate(date) { (rates) in
            self.usdRateLabel.text = rates[0]
            self.eurRateLabel.text = rates[1]
        }
        
        
        


    }
    
    func getRateForDate(_ date: String, complition: @escaping ([String]) -> Void) {
        let basicURL = "https://www.cbr.ru/scripts/XML_daily.asp?date_req="
        let requestURL = basicURL + date
        
        var rates = ["", ""]
        
        Alamofire.request(requestURL, method: .get).responseData { (response) in
            if let value = response.value {
                //                print(value)
                let parser = XMLParser(data: value)
                parser.delegate = self
                if parser.parse() {
                    //                    print(self.results ?? "No results")
                    for index in 0..<self.results!.count {
                        //                        print(self.results![index])
                        let result = self.results![index]
                        for (_, _) in result {
                            if result["CharCode"] == "USD" {
                                rates[0] = result["Value"]!
                            }
                            if result["CharCode"] == "EUR" {
                                rates[1] = result["Value"]!
                            }
                        }
                    }
                }
                complition(rates)
            }
        }
    }
}

extension RateViewController: XMLParserDelegate {
    
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results?.append(currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = nil
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        
        currentValue = nil
        currentDictionary = nil
        results = nil
    }
}
