//import Foundation
//import CoreLocation
//
//class DummyDataGenerator {
//    static let shared = DummyDataGenerator()
//    private let dbUtils = DBUtils.shared
//    
//    private init() {}
//    
//    func generateCompleteTestScenario() {
//        // Clear existing data
//        dbUtils.dropTable(command: .Worker)
//        dbUtils.dropTable(command: .WorkPlace)
//        dbUtils.dropTable(command: .WorkLog)
//        
//        dbUtils.createTable(command: .Worker)
//        dbUtils.createTable(command: .WorkPlace)
//        dbUtils.createTable(command: .WorkLog)
//        
//        // 1. Create and insert user data
//        let worker = WorkerModel(name: "홍길동", email: "hong@example.com")
//        _ = dbUtils.writeData(command: .Worker, mode: .insert, id: 0, model: worker as AnyObject)
//        print("Inserted worker: \(worker.name)")
//        
//        // 2. Create and insert workplace data
//        let workplace = WorkPlaceModel(
//            workPlaceName: "테스트 회사",
//            workPlaceAddress: "서울특별시 강남구 테헤란로 123",
//            workPlaceLocation: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
//            hourlyWage: 10000
//        )
//        _ = dbUtils.writeData(command: .WorkPlace, mode: .insert, id: 0, model: workplace as AnyObject)
//        print("Inserted workplace: \(workplace.workPlaceName)")
//        
//        // 3. Create and insert work logs (simulating 출근 and 퇴근)
//        let calendar = Calendar.current
//        let now = Date()
//        
//        for i in 0..<30 {  // Generate 30 days of data
//            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
//            
//            let startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: date)!
//            let endTime = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: date)!
//            
//            let workLog = WorkLogModel(
//                date: date,
//                startTime: startTime,
//                endTime: endTime,
//                startPosition: workplace.workPlaceLocation,
//                endPosition: workplace.workPlaceLocation
//            )
//            
//            _ = dbUtils.writeData(command: .WorkLog, mode: .insert, id: 0, model: workLog as AnyObject)
//            print("Inserted work log for date: \(date)")
//            
//            let result = dbUtils.writeData(command: .WorkLog, mode: .insert, id: 0, model: workLog as AnyObject)
//            print("Inserted work log for date: \(date), result: \(result)")
//        }
//        
//        print("Complete test scenario data generated successfully")
//    }
//}
