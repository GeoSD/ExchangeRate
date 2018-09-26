//
//  DateTableViewController.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {
    
    var loadMore = false
    let today = Date()
    var dates = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        dates.append(today)
        print(dates)
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
        
        print("\(offsetY)   \(contentHeight - scrollView.frame.height)")
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !loadMore {
                loadMoreDates()
            }
        }
    }
    
    func loadMoreDates() {
        loadMore = true
        print("Start loading more...")
        
        var newArray = self.dates
        newArray = [self.dates.last! - 1 * 86400, self.dates.last! - 2 * 86400, self.dates.last! - 3 * 86400, self.dates.last! - 4 * 86400, self.dates.last! - 5 * 86400, self.dates.last! - 6 * 86400, self.dates.last! - 7 * 86400, self.dates.last! - 8 * 86400, self.dates.last! - 9 * 86400, self.dates.last! - 10 * 86400, ]
        self.dates.append(contentsOf: newArray)
        self.loadMore = false
        self.tableView.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            var newArray = self.dates
//            newArray = [self.dates.last! + 1, self.dates.last! + 2, self.dates.last! + 3, self.dates.last! + 4, self.dates.last! + 5, self.dates.last! + 6, self.dates.last! + 7, self.dates.last! + 8, self.dates.last! + 9, self.dates.last! + 10, ]
//            self.dates.append(contentsOf: newArray)
//            self.loadMore = false
//            self.tableView.reloadData()
//        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getRateForDate() {
//        http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002
    }
}
