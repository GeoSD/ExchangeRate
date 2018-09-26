//
//  DateTableViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit
import Alamofire

class DateTableViewController: UITableViewController {
    
    var loadMore = false
    let today = Date()
    var dates = [Date]()
    var ratesForDate = [String]()
    
    let recordKey = "Valute"
    let dictionaryKeys = Set<String>(["CharCode", "Value"])
    
    var results: [[String: String]]?
    var currentDictionary: [String: String]?
    var currentValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<15 {
            let day: Date = today - TimeInterval(86400 * index)
            dates.append(day)
        }
        
        //        print(dates)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: dates[indexPath.row])
        cell.textLabel?.text = dateString
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !loadMore {
                loadMoreDates()
            }
        }
    }
    
    func loadMoreDates() {
        loadMore = true
        //        print("Start loading more...")
        
        var newArray = self.dates
        newArray = [self.dates.last! - 1 * 86400, self.dates.last! - 2 * 86400, self.dates.last! - 3 * 86400,
                    self.dates.last! - 4 * 86400, self.dates.last! - 5 * 86400, self.dates.last! - 6 * 86400,
                    self.dates.last! - 7 * 86400, self.dates.last! - 8 * 86400, self.dates.last! - 9 * 86400,
                    self.dates.last! - 10 * 86400, self.dates.last! - 11 * 86400, self.dates.last! - 12 * 86400]
        
        self.dates.append(contentsOf: newArray)
        self.loadMore = false
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRates" {
            
            let indexPathRow = tableView.indexPathForSelectedRow?.row
            let ratesVC = segue.destination as! RateViewController
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: dates[indexPathRow!])
            //            print(dateString)
            
            ratesVC.date = dateString
            ratesVC.rateForDate = getRateForDate(dateString)
        }
    }
    
    func getRateForDate(_ date: String) -> [String] {
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
            }
        }
        return rates
    }
}

extension DateTableViewController: XMLParserDelegate {
    
    
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
