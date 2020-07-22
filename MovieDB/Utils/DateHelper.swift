//
//  DateHelper.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

final class DateHelper {
    static let shared = DateHelper()
    
    private let dateFormatter: DateFormatter
    private let expectedFormat = "yyyy-MM-dd"
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = expectedFormat
    }
    
    func getYearFrom(string: String) -> String? {
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date)
        return "\(components.year ?? 0)"
    }
}
