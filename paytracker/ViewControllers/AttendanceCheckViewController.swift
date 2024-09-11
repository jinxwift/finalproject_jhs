import UIKit
import CoreLocation
import MapKit

class AttendanceCheckViewController: UIViewController {
    
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var mapUIView: MKMapView!
    @IBOutlet weak var btnRegist: UIButton!
    
    var locationManager: CLLocationManager?
    var isCheckAttended: Bool = false
    
    var currentLocation: CLLocationCoordinate2D?
    
    let dbUtils = DBUtils()
    let commonUtils = CommonUtils()
    
    var currentPosition: CLLocationCoordinate2D?
    var workLog: WorkLogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupUI()
        updateCurrentDateTime()
        setupDataBase()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    private func setupUI() {
        self.navigationItem.title = isCheckAttended ? "퇴근등록" : "출근등록"
        self.btnRegist.setTitle(isCheckAttended ? "퇴근" : "출근", for: .normal)
        updateCurrentDateTime()
    }
    
    private func updateCurrentDateTime() {
        self.lblToday.text = Date.getCurrentDate()
        self.lblCurrentTime.text = Date.getCurrentTime()
    }
    
    private func setupMapView() {
        guard let currentLocation = currentPosition else {
            return
        }
        
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation
        annotation.title = "현재 위치"
        
        self.mapUIView.setRegion(region, animated: true)
        self.mapUIView.removeAnnotations(self.mapUIView.annotations)
        self.mapUIView.addAnnotation(annotation)
    }
    
    private func setupDataBase() {
        _ = dbUtils.createTable(command: .WorkLog)
    }
    
    @IBAction func doRegist(_ sender: Any) {
        updateCurrentDateTime()
        
        guard let currentDateString = self.lblToday.text,
              let currentTimeString = self.lblCurrentTime.text,
              let currentDate = commonUtils.stringToDate(dateFormattedString: self.lblToday.text!, format: "yyyy-MM-dd"),
                let currentTime = commonUtils.stringToDate(dateFormattedString: self.lblCurrentTime.text!, format: "HH:mm"),
              let currentPosition = self.currentPosition else {
            showToast(self.view, message: "위치 정보를 가져올 수 없습니다.")
            return
        }
        
        if !isCheckAttended {
            // 출근 등록
            workLog = WorkLogModel(
                date: currentDate,
                startTime: currentTime,
                endTime: currentTime,
                startPosition: currentPosition,
                endPosition: currentPosition)
            
            if dbUtils.writeData(command: .WorkLog, mode: .insert, id: 0, model: workLog as AnyObject) {
                showToast(self.view, message: "출근 등록이 완료되었습니다.")
                isCheckAttended = true
                self.navigationItem.title = "퇴근등록"
                self.btnRegist.setTitle("퇴근", for: .normal)
            } else {
                showToast(self.view, message: "출근 등록에 실패했습니다.")
            }
        } else {
            // 퇴근 등록
            if var existingWorkLogs = dbUtils.readData(command: .WorkLog) as? [WorkLogModel],
               var lastLog = existingWorkLogs.last {
                lastLog.endTime = currentTime
                lastLog.endPosition = currentPosition
                
                if dbUtils.writeData(command: .WorkLog, mode: .update, id: 0, model: lastLog as AnyObject) {
                    showToast(self.view, message: "퇴근 등록이 완료되었습니다.")
                    isCheckAttended = false
                    self.navigationItem.title = "출근등록"
                    self.btnRegist.setTitle("출근", for: .normal)
                } else {
                    showToast(self.view, message: "퇴근 등록에 실패했습니다.")
                }
            } else {
                showToast(self.view, message: "출근 기록을 찾을 수 없습니다.")
            }
        }
    }
    
    func getDistance(workerPosition: CLLocationCoordinate2D, workPlacePosition: CLLocationCoordinate2D) -> Double {
        let workerLocation = CLLocation(latitude: workerPosition.latitude, longitude: workerPosition.longitude)
        let workPlaceLocation = CLLocation(latitude: workPlacePosition.latitude, longitude: workPlacePosition.longitude)
        
        return workerLocation.distance(from: workPlaceLocation)
    }
    
    func isAttend(distance: Double) -> Bool {
        print("Distance = \(distance)")
        return distance <= 20.00
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: .curveEaseOut,
                       animations: {
            toastLabel.alpha = 0.0
        },
                       completion: { (finished) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension AttendanceCheckViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        
        currentLocation = location
        currentPosition = location
        setupMapView()
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
}
