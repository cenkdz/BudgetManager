//
//  EntryFiller.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 3.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import Foundation


class EntryFiller{
    var desiredDate: Date
    var firebaseEntries = [Entry]()
    var thebestentries = [[Entry]]()
    var hehe = [Entry]()
    var entries: [[Entry]] = []
    
    init(desiredDate: Date) {
        self.desiredDate = desiredDate
    }
    
    func getDays(entry: [Entry]) -> [String] {
        var days: [String] = []
        
        for entry in firebaseEntries {
            let dayData = entry.day
            
            if !days.contains(dayData){
                days.append(dayData)
            }
            
            
        }
        
        let sortedDays = days.sorted {
            Int($0)! > Int($1)!
        }
        
        
        return sortedDays
    }
    
    func getWeeks(entry: [Entry]) -> [String] {
        var weeks: [String] = []
        
        for entry in firebaseEntries {
            let weekData = entry.weekOfMonth

            
            if !weeks.contains(weekData){
                weeks.append(weekData)
            }
            
            
        }
        
        let sortedWeeks = weeks.sorted {
            $0 < $1
        }
        
        dump(sortedWeeks)
        return sortedWeeks
    }
    
    func setData(){
        
        let sortedArray = entries.sorted(by: {$0[0].day > $1[0].day })
        entries.removeAll()
        entries.append(contentsOf: sortedArray)
        
    }
    
    func sortDays(){
        
        for element in entries.matrixIterator() {
            print(element)
        }
        
        //dayEntry.append(DayEntry.init(day: <#T##String#>, entry: <#T##[Entry]#>))
    }
    
    
    //    func setData() {
    //        let sortedArray = entries.sorted(by: { $0[0].day > $1[0].day })
    //        entries.removeAll()
    //        entries.append(contentsOf: sortedArray)
    //    }
    
    //Currents Month's Entries
    func thebest(){
        self.entries = []
        self.thebestentries = []
        self.hehe = []
        
        for day in getDays(entry: firebaseEntries) {
            if !hehe.isEmpty {
                hehe.removeAll()
            }
            let day = day
            
            for entry in firebaseEntries {
                let month = entry.month
                
                if entry.day == day {
                    if month == String(Calendar.current.component(.month, from: desiredDate)){
                            hehe.append(entry)
                        
                    }
                }
            }
            thebestentries.append(hehe)
        }
        //let sortedArray = thebestentries.sorted(by: {$0[0].day > $1[0].day })
        // entries.removeAll()
        
        entries = thebestentries
        prepare_array(cEntries: entries)

        
        
    }
    
    func thebest2(){
        self.entries = []
        self.thebestentries = []
        self.hehe = []
        
        for weekOfMonth in getWeeks(entry: firebaseEntries) {
            if !hehe.isEmpty {
                hehe.removeAll()
            }
            let weekOfMonth = weekOfMonth
            
            for entry in firebaseEntries {
                let month = entry.month
                
                if entry.weekOfMonth == weekOfMonth {
                    
                    if month == String(Calendar.current.component(.month, from: desiredDate)){
                        
                            
                            hehe.append(entry)
                        
                    }
                }
            }
            
            thebestentries.append(hehe)
            
        }
        //let sortedArray = thebestentries.sorted(by: {$0[0].day > $1[0].day })
        // entries.removeAll()
        entries = thebestentries
        prepare_array(cEntries: entries)

        
    }
    // Current Day
    func thebest3(){
        self.entries = []
        self.thebestentries = []
        self.hehe = []
        if !hehe.isEmpty {
            hehe.removeAll()
        }
        
        for entry in firebaseEntries {
        print(desiredDate)
            print("Day\(String(Calendar.current.component(.day, from: desiredDate)))")
            print("Month\(String(Calendar.current.component(.month, from: desiredDate)))")
            print("Year\(String(Calendar.current.component(.year, from: desiredDate)))")


            let month = entry.month
            let year = entry.year
            
      
                
                if month == String(Calendar.current.component(.month, from: desiredDate)) && year == String(Calendar.current.component(.year, from: desiredDate)) && entry.day == String(Calendar.current.component(.day, from: desiredDate))  {
                    
                        hehe.append(entry)
                    
                    
                }
            
        }
        thebestentries.append(hehe)
        entries = thebestentries
        
        prepare_array(cEntries: entries)
        

        
    }
    
    private func prepare_array(cEntries: [[Entry]])
        {

        entries = cEntries.filter({ $0.count != 0})
        }
}

fileprivate extension Array where Element : Collection, Element.Index == Int {
    
    typealias InnerCollection = Element
    typealias InnerElement = InnerCollection.Iterator.Element
    
    func matrixIterator() -> AnyIterator<InnerElement> {
        var outerIndex = self.startIndex
        var innerIndex: Int?
        
        return AnyIterator({
            guard !self.isEmpty else { return nil }
            
            var innerArray = self[outerIndex]
            if !innerArray.isEmpty && innerIndex == nil {
                innerIndex = innerArray.startIndex
            }
            
            // This loop makes sure to skip empty internal arrays
            while innerArray.isEmpty || (innerIndex != nil && innerIndex! == innerArray.endIndex) {
                outerIndex = self.index(after: outerIndex)
                if outerIndex == self.endIndex { return nil }
                innerArray = self[outerIndex]
                innerIndex = innerArray.startIndex
            }
            
            let result = self[outerIndex][innerIndex!]
            innerIndex = innerArray.index(after: innerIndex!)
            
            return result
        })
    }
    
}

extension NSCountedSet {
    var occurences: [(object: Any, count: Int)] { map { ($0, count(for: $0))} }
    var dictionary: [AnyHashable: Int] {
        reduce(into: [:]) {
            guard let key = $1 as? AnyHashable else { return }
            $0[key] = count(for: key)
        }
    }
}
