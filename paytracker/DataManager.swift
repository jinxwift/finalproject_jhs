//
//  DataManager.swift
//  paytracker
//
//  Created by Jude Song on 9/6/24.
//

import Foundation
import CoreLocation

class DataManager {
    static let shared = DataManager()
    var currentWorkPlace: WorkPlaceModel?
    private init() {}
}
