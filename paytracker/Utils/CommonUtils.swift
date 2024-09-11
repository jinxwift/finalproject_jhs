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
    
    func stringToDate(dateFormattedString: String, format: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        return dateFormatter.date(from: dateFormattedString)!
    }
    
    func locationToString(location: CLLocationCoordinate2D) -> String {
        return "\(location.latitude)|\(location.longitude)"
    }
    
    func stringToLocation(locationFormattedString: String) -> CLLocationCoordinate2D {
        let latitude: Double =  Double(locationFormattedString.split(separator: "|")[0]) ?? 0.0
        let longtitude: Double = Double(locationFormattedString.split(separator: "|")[1]) ?? 0.0
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
}
