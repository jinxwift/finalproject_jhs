import Foundation
import CoreLocation

// MARK: - Worker (근로자)

struct Worker: Codable {
    let id: String
    var name: String    // 근로자 이름
    var email: String   // 근로자 이메일
    
    init(id: String = UUID().uuidString, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: - Workplace (근무지)

struct Workplace: Codable {
    let id: String
    var name: String        // 근무지 상호명
    var address: String     // 근무지 주소
    var hourlyRate: Decimal // 근무지 시급
    
    init(id: String = UUID().uuidString, name: String, address: String, hourlyRate: Decimal) {
        self.id = id
        self.name = name
        self.address = address
        self.hourlyRate = hourlyRate
    }
}

// MARK: - WorkLog (근무 기록)

struct WorkLog: Codable {
    let id: String
    var date: Date
    var startTime: Date             // 출근 시간
    var endTime: Date?              // 퇴근 시간
    var startPosition: CLLocationCoordinate2D?  // 출근 당시 위치 정보
    var endPosition: CLLocationCoordinate2D?    // 퇴근 당시 위치 정보
    var workplace: Workplace
    
    var duration: TimeInterval {    // 근무 시간
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var earnings: Decimal {         // 일일 급여 액수
        Decimal(duration / 3600) * workplace.hourlyRate
    }
    
    init(id: String = UUID().uuidString, date: Date, startTime: Date, endTime: Date? = nil, startPosition: CLLocationCoordinate2D? = nil, endPosition: CLLocationCoordinate2D? = nil, workplace: Workplace) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.workplace = workplace
    }
}

// MARK: - AppState (앱 상태)

class AppState {
    static let shared = AppState()
    
    var currentWorker: Worker?              // 현재 근로자 정보
    var workplaces: [Workplace] = []        // 근무지 목록
    var workLogs: [WorkLog] = []            // 모든 근무 기록
    
    private init() {}
    
    // 총 근무 일수 계산
    func calculateTotalWorkDays() -> Int {
        Set(workLogs.map { Calendar.current.startOfDay(for: $0.date) }).count
    }
    
    // 근무 기간 계산 (첫 근무일부터 마지막 근무일까지의 일 수)
    func calculateWorkPeriod() -> Int {
        guard let firstDate = workLogs.map({ $0.date }).min(),
              let lastDate = workLogs.map({ $0.date }).max() else {
            return 0
        }
        return Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0 + 1 // +1 to include both start and end dates
    }
    
    // 특정 기간 동안의 근무 기록 가져오기
    func getWorkLogs(from startDate: Date, to endDate: Date) -> [WorkLog] {
        workLogs.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    // 특정 기간 동안의 총 근무 시간 계산
    func calculateTotalDuration(from startDate: Date, to endDate: Date) -> TimeInterval {
        getWorkLogs(from: startDate, to: endDate).reduce(0) { $0 + $1.duration }
    }
    
    // 특정 기간 동안의 총 급여 액수 계산 (세전)
    func calculateTotalEarnings(from startDate: Date, to endDate: Date) -> Decimal {
        getWorkLogs(from: startDate, to: endDate).reduce(Decimal(0)) { $0 + $1.earnings }
    }
    
    // 특정 기간 동안의 총 세금 계산
    func calculateTotalTax(from startDate: Date, to endDate: Date, taxRate: Decimal = 0.033) -> Decimal {
        calculateTotalEarnings(from: startDate, to: endDate) * taxRate
    }
    
    // 특정 기간 동안의 실수령액 계산
    func calculateNetEarnings(from startDate: Date, to endDate: Date, taxRate: Decimal = 0.033) -> Decimal {
        let totalEarnings = calculateTotalEarnings(from: startDate, to: endDate)
        let totalTax = calculateTotalTax(from: startDate, to: endDate, taxRate: taxRate)
        return totalEarnings - totalTax
    }
}
// MARK: - Codable Extensions

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitude = try container.decode(Double.self)
        let longitude = try container.decode(Double.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}
