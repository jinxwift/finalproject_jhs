//
//  Model.swift
//  paytracker
//
//  Created by
//

import Foundation
import CoreLocation

struct WorkPlaceModel {
    var id: String
    var workPlaceName: String
    var workPlaceAddress: String
    var workPlaceLocation: CLLocationCoordinate2D
    var hourlyWage: Int
    
    init(id: String = UUID().uuidString, workPlaceName: String, workPlaceAddress: String, workPlaceLocation:CLLocationCoordinate2D, hourlyWage: Int) {
        self.id = id
        self.workPlaceName = workPlaceName
        self.workPlaceAddress = workPlaceAddress
        self.workPlaceLocation = workPlaceLocation
        self.hourlyWage = hourlyWage
    }
}

struct WorkerModel {
    let id: String
    var name: String    // 근로자 이름
    var email: String   // 근로자 이메일
    
    init(id: String = UUID().uuidString, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

struct WorkLogModel {
    var id: String
    var date: Date
    var startTime: Date                         // 출근 시간
    var endTime: Date                           // 퇴근 시간
    var startPosition: CLLocationCoordinate2D   // 출근 당시 위치 정보
    var endPosition: CLLocationCoordinate2D     // 퇴근 당시 위치 정보
    var workPlace: WorkPlaceModel
    
    init(id: String = UUID().uuidString, date: Date, startTime: Date, endTime: Date, startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D, workPlace: WorkPlaceModel) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.workPlace = workPlace
    }
}
