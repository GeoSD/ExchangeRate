//
//  RateService.swift
//  ExchangeRate
//
//  Created by Georgy Dyagilev on 26/09/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import Foundation
import Alamofire

class RateService: UIViewController {
    
    // Вспомогательные переменные для работы с XML.
    let recordKey = "Valute" // Ключ по которому извлекаются записи.
    let dictionaryKeys = Set<String>(["CharCode", "Value"]) // Словарь ключей по которым извлекаются необходимые значения в записях.
    
    var results: [[String: String]]? // Результат обработки XML.
    var currentDictionary: [String: String]? // Вспомогательный словарь для обработки текущей записи.
    var currentValue: String? // Текущее значение по заданному ключу из словаря ключей.
    
    // Фунцкия получения курса валют на заданную дату.
    func getRateForDate(_ date: String, complition: @escaping ([String]) -> Void) {
        let basicURL = "https://www.cbr.ru/scripts/XML_daily.asp?date_req="
        let requestURL = basicURL + date
        
        var rates = ["", ""]
        
        // Работа с сетью, и обработка результата. Возвращает необходимые данные.
        Alamofire.request(requestURL, method: .get).responseData { (response) in
            if let value = response.value {
                let parser = XMLParser(data: value)
                parser.delegate = self
                if parser.parse() {
                    for index in 0..<self.results!.count {
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

// Расширение функионала класса для обработки XML данных.
extension RateService: XMLParserDelegate {
    
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
