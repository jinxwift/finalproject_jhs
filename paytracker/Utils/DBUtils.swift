//
//  DBUtils.swift
//  paytracker
//
//  Created by Myeong chul Kim on 9/9/24.
//

import Foundation
import SQLite3
import CoreLocation

class DBUtils {
    enum Command {
        case Worker
        case WorkPlace
        case WorkLog
    }
    
    enum Mode {
        case none
        case insert
        case update
        case delete
    }
    
    var database: OpaquePointer?
    let commonUtils = CommonUtils()
    
    func createTable(command: Command) -> Bool {
        var query = ""
        
        let fileURL = try! FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false).appendingPathComponent("PayTrackerDatabase.sqlite")
            if sqlite3_open(fileURL.path, &self.database) != SQLITE_OK {
                print("table not exsist")
            }
        
        switch (command) {
        case .WorkLog:
            query = "CREATE TABLE IF NOT EXISTS TBL_WORK (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, start_time TEXT, end_time TEXT, start_position TEXT, end_position TEXT)"
            break
        case .Worker:
            query = "CREATE TABLE IF NOT EXISTS TBL_WORKER (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)"
            break
        case .WorkPlace:
            query = "CREATE TABLE IF NOT EXISTS TBL_WORKPLACE (id INTEGER PRIMARY KEY AUTOINCREMENT, workplace_name TEXT, workplace_address TEXT, workplace_location TEXT, hourly_wage INTEGER NOT NULL)"
            break
        }
        
        if sqlite3_exec(self.database, query, nil, nil, nil) != SQLITE_OK {
            let errorMsg = String(cString: sqlite3_errmsg(self.database))
            print("cannot create table: \(errorMsg)")
            return false
        } else {
            print("OK")
            return true
        }
    }
    
    func writeData(command: Command, mode: Mode, id: Int, model: AnyObject) -> Bool {
        
        var statement: OpaquePointer?
        var query = ""
        
        switch(command) {
        case .WorkLog:
            let workLog = model as! WorkLogModel
            let date = commonUtils.dateToString(date: workLog.date, format: "yyyy-MM-dd")
            let startTime = commonUtils.dateToString(date: workLog.startTime, format: "HH:mm")
            let endTime = commonUtils.dateToString(date: workLog.endTime, format: "HH:mm")
            let startPosition = commonUtils.locationToString(location: workLog.startPosition)
            let endPosition = commonUtils.locationToString(location:workLog.endPosition)
            print("date = \(date), start_time = \(startTime), end_time = \(endTime), start_position  = \(startPosition), end_position = \(endPosition)")
            if (mode == .insert) {
                query = "INSERT INTO TBL_WORK (date, start_time, end_time, start_position, end_position) VALUES ('\(date)','\(startTime)','\(endTime)', '\(startPosition)', '\(endPosition)');"
            } else if (mode == .update) {
                query = "UPDATE TBL_WORK SET date = '\(date)', start_time = '\(startTime)', end_time = '\(endTime)', start_position = '\(startPosition)', end_position = '\(endPosition)' WHERE id == '\(id)'"
            } else {
                print("invalid mode")
                return false
            }
            break
        case .Worker:
            let worker = model as! WorkerModel
            let name = worker.name
            let email = worker.email
            print("name = \(name), email = \(email)")
            if (mode == .insert) {
                query = "INSERT INTO TBL_WORKER (name, email) VALUES ('\(name)', '\(email)');"
            } else if (mode == .update) {
                query = "UPDATE TBL_WORKER SET name = '\(name)', email = '\(email)' WHERE id == 1"
            } else {
                print("invalid mode")
                return false
            }
            break
        case .WorkPlace:
            let workPlace = model as! WorkPlaceModel
            let workPlaceName = workPlace.workPlaceName
            let workPlaceAddress = workPlace.workPlaceAddress
            let workPlaceLocation = commonUtils.locationToString(location: workPlace.workPlaceLocation)
            let hourlyWage = workPlace.hourlyWage
            print("workPlace = \(workPlace)")
            if (mode == .insert) {
                query = "INSERT INTO TBL_WORKPLACE (workplace_name, workplace_address, workplace_location, hourly_wage) VALUES ('\(workPlaceName)', '\(workPlaceAddress)', '\(workPlaceLocation)', '\(hourlyWage)');"
            } else if (mode == .update) {
                query = "UPDATE TBL_WORKPLACE SET workplace_name = '\(workPlaceName)', workplace_address = '\(workPlaceAddress)', workplace_location = '\(workPlaceLocation)', hourly_wage = '\(hourlyWage)' WHERE id == '\(id)'"
            } else {
                print("invalid mode")
                return false
            }
            break
        }
        
        if sqlite3_prepare_v2(self.database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("[write data] \(String(describing: self.database))")
                sqlite3_finalize(statement)
                return true
            } else{
                let errorMessage = String(cString: sqlite3_errmsg(self.database))
                print("[write data]  \(errorMessage)")
                sqlite3_finalize(statement)
                return false
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            print("[write data] :\(errorMessage)")
            sqlite3_finalize(statement)
            return false
        }
    }
    
    func readData(command: Command) -> AnyObject? {
        
        var statement : OpaquePointer? = nil
        var query = ""
        
        switch (command) {
        case .WorkLog:
            query = "SELECT * FROM TBL_WORK;"
            break
        case .Worker:
            query = "SELECT * FROM TBL_WORKER;"
            break
        case .WorkPlace:
            query = "SELECT * FROM TBL_WORKPLACE;"
            break
        }
        
        
        if sqlite3_prepare_v2(self.database, query, -1, &statement, nil) == SQLITE_OK {
            
            switch (command) {
            case .WorkLog:
                var workLogs = [WorkLogModel]()
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    var workLog = WorkLogModel(date: Date(), startTime: Date(), endTime: Date(), startPosition: CLLocationCoordinate2D(), endPosition: CLLocationCoordinate2D())
                    workLog.date = commonUtils.stringToDate(dateFormattedString: String(cString: sqlite3_column_text(statement, 1)), format: "yyyy-MM-dd")
                    workLog.startTime = commonUtils.stringToDate(dateFormattedString: String(cString: sqlite3_column_text(statement, 2)), format: "HH:mm:ss")
                    workLog.endTime = commonUtils.stringToDate(dateFormattedString: String(cString: sqlite3_column_text(statement, 3)), format: "HH:mm:ss")
                    workLog.startPosition = commonUtils.stringToLocation(locationFormattedString: String(cString: sqlite3_column_text(statement, 4)))
                    workLog.endPosition = commonUtils.stringToLocation(locationFormattedString: String(cString: sqlite3_column_text(statement, 5)))
                    
                    workLogs.append(workLog)
                }
                sqlite3_finalize(statement)
                return workLogs as AnyObject
                
            case .Worker:
                var worker = WorkerModel(name: "", email: "")
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    // 읽은 Data 변수에 담기
                    worker.name =  String(cString: sqlite3_column_text(statement, 1))
                    worker.email = String(cString: sqlite3_column_text(statement, 2))
                }
                sqlite3_finalize(statement)
                return worker as AnyObject
                
            case .WorkPlace:
                var workPlace = WorkPlaceModel(workPlaceName: "", workPlaceAddress: "", workPlaceLocation: CLLocationCoordinate2D(), hourlyWage: 0)
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    workPlace.workPlaceName = String(cString: sqlite3_column_text(statement, 1))
                    workPlace.workPlaceAddress = String(cString: sqlite3_column_text(statement, 2))
                    workPlace.workPlaceLocation = commonUtils.stringToLocation(locationFormattedString: String(cString: sqlite3_column_text(statement, 3)))
                    workPlace.hourlyWage = Int(sqlite3_column_int(statement, 4))
                }
                sqlite3_finalize(statement)
                return workPlace as AnyObject
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.database))
            print("[read data] prepare fail! : \(errorMessage)")
        }
        
        return nil
    }
    
    func dropTable(command: Command) -> Bool {
        
        return true
    }
}
