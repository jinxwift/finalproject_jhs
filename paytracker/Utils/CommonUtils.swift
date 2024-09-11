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
}
