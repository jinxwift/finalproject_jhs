//
//  CommonUtils.swift
//  paytracker
//
//  Created by Myeong chul Kim on 9/11/24.
//

import Foundation
import CoreLocation

class CommonUtils {
    
    func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(dateFormattedString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: dateFormattedString)
    }
    
    func locationToString(location: CLLocationCoordinate2D) -> String {
        return "\(location.latitude)|\(location.longitude)"
    }
    
    func stringToLocation(locationFormattedString: String) -> CLLocationCoordinate2D? {
        let components = locationFormattedString.split(separator: "|")
        guard components.count == 2,
              let latitude = Double(components[0]),
              let longitude = Double(components[1]) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func timeDiff(start: String, end: String) -> Int {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
                
        guard let startTime = format.date(from: start) else {return 0}
        guard let endTime = format.date(from: end) else {return 0}

        var result = Int(endTime.timeIntervalSince(startTime))
        return result
    }
}
