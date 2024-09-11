//
//  AttendanceCheckViewController.swift
//  paytracker
//
//  Created by Myeong chul Kim on 8/29/24.
//

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
    var timer: Timer?
    
    let dbUtils = DBUtils()
    let commonUtils = CommonUtils()
    
    var currentPosition: CLLocationCoordinate2D?
    var workLog: WorkLogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AttendanceCheckViewController: viewDidLoad")
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        
        currentLocation = locationManager?.location?.coordinate
        
        self.navigationItem.title = isCheckAttended ? "퇴근등록":"출근등록"
        self.btnRegist.titleLabel?.text = isCheckAttended ? "퇴근":"출근"
        
        self.lblToday.text = Date.getCurrentDate()
        //        self.lblCurrentTime.text = Date.getCurrentTime()
        updateCurrentTime()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        
        if lblCurrentTime == nil {
            print("Error: lblCurrentTime is nil")
        }
        
        print("lblCurrentTime frame: \(String(describing: lblCurrentTime?.frame))")
        
        // 출근지 위치
        currentPosition = CLLocationCoordinate2D(
            latitude: currentLocation?.latitude ?? 37.5665,
            longitude: currentLocation?.longitude ?? 126.9780)

        let region = MKCoordinateRegion(center: currentPosition!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: currentLocation?.latitude ?? 37.5665,
            longitude: currentLocation?.longitude ?? 126.9780)
        annotation.title = "출근 위치"

        self.mapUIView.setRegion(region, animated: true)
        self.mapUIView.addAnnotation(annotation)
        
//        let defaultLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        setupMapView(with: currentPosition!)
    }
    
    @objc func updateCurrentTime() {
        let currentTime = Date.getCurrentTime()
        self.lblCurrentTime.text = currentTime
        
        // Debug: Print current time
        print("Current time updated: \(currentTime)")
        
        // Debug: Check if text is set correctly
        print("lblCurrentTime text: \(String(describing: lblCurrentTime.text))")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupDataBase() {
        _ = dbUtils.createTable(command: .WorkLog)
    }
    
    private func setupMapView(with location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "현재 위치"
        
        self.mapUIView.setRegion(region, animated: true)
        self.mapUIView.removeAnnotations(self.mapUIView.annotations)
        self.mapUIView.addAnnotation(annotation)
    }
    
    @IBAction func doRegist(_ sender: Any) {
//        let workPlaceLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
//        if (isAttend(distance: getDistance(workerPosition: currentLocation!, workPlacePosition: workPlaceLocation))) {
            print("Attend")
            workLog = WorkLogModel(
                date: commonUtils.stringToDate(dateFormattedString: self.lblToday.text!, format: "yyyy-MM-dd"),
                startTime: commonUtils.stringToDate(dateFormattedString: self.lblCurrentTime.text!, format: "HH:mm"),
                endTime: commonUtils.stringToDate(dateFormattedString: self.lblCurrentTime.text!, format: "HH:mm"),
                startPosition: self.currentPosition!, endPosition: self.currentPosition!)
            if (dbUtils.writeData(command: .WorkLog, mode: .insert, id: 0, model: workLog! as AnyObject)) {
                print("OK")
                showToast(self.view, message: "\(isCheckAttended ? "퇴근":"출근") 등록이 완료 되었습니다.")
                if (isCheckAttended) {
                    isCheckAttended = true
                }
            } else {
                print("Error")
            }
//        } else {
//            print("Absent")
//        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func getDistance(workerPosition: CLLocationCoordinate2D, workPlacePosition: CLLocationCoordinate2D) -> Double {
        let workerLocation = CLLocation(latitude: workerPosition.latitude, longitude: workerPosition.longitude)
        let workPlaceLocation = CLLocation(latitude: workPlacePosition.latitude, longitude: workPlacePosition.longitude)
        
        return workerLocation.distance(from: workPlaceLocation)
    }
    
    func isAttend(distance: Double) -> Bool {
        print("Distance = \(distance)")
        return distance <= 20.00 ? true : false
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: UIView.AnimationOptions.curveEaseOut,
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
        setupMapView(with: location)
        
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
