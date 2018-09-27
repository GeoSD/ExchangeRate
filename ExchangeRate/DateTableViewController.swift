//
//  DateTableViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {
    
    let today = Date()
    var dates = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<15 {
            let day: Date = today - TimeInterval(86400 * index)
            dates.append(day)
        }
    }
    
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
            loadMoreDates()
        }
    }
    
    func loadMoreDates() {
        var newArray = dates
        newArray = [dates.last! - 1 * 86400, dates.last! - 2 * 86400, dates.last! - 3 * 86400,
                    dates.last! - 4 * 86400, dates.last! - 5 * 86400, dates.last! - 6 * 86400,
                    dates.last! - 7 * 86400, dates.last! - 8 * 86400, dates.last! - 9 * 86400,
                    dates.last! - 10 * 86400, dates.last! - 11 * 86400, dates.last! - 12 * 86400]
        
        dates.append(contentsOf: newArray)
        tableView.reloadData()
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRates" {
            
            let indexPathRow = tableView.indexPathForSelectedRow?.row
            let ratesVC = segue.destination as! RateViewController
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: dates[indexPathRow!])

            ratesVC.date = dateString
        }
    }
}

