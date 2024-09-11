//
//  ViewController.swift
//  paytracker
//
//  Created by Jude Song on 8/22/24.
//

import UIKit
import MapKit
import Foundation

class WorkPlaceViewController: UIViewController {
    
    @IBOutlet weak var barButtonClose: UIBarButtonItem!
    @IBOutlet weak var inputTextWorkPlaceName: UITextField!
    @IBOutlet weak var inputTextWorkPlaceAddress: UITextField!
    @IBOutlet weak var inputTextHourlyWage: UITextField!
    @IBOutlet weak var btnSearchWorkPlaceLocation: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var mapUIView: MKMapView!
    
    var location: CLLocationCoordinate2D?
    var workPlaceModel: WorkPlaceModel?
    var isExistWorkPlace = false
    
    let dbUtils = DBUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = dbUtils.createTable(command: .WorkPlace)
        
        title = "근무지"
//        if let workPlace = DataManager.shared.currentWorkPlace {
//            inputTextWorkPlaceName.text = workPlace.workPlaceName
//            inputTextWorkPlaceAddress.text = workPlace.workPlaceAddress
//            inputTextHourlyWage.text = "\(workPlace.hourlyWage)"
//        }
        
        workPlaceModel = dbUtils.readData(command: .WorkPlace) as? WorkPlaceModel
        var latitude = 37.566691
        var longtutude = 126.978365
        
        if (workPlaceModel != nil) {
            inputTextWorkPlaceName.text = workPlaceModel?.workPlaceName
            inputTextWorkPlaceAddress.text = workPlaceModel?.workPlaceAddress
            inputTextHourlyWage.text = "\(workPlaceModel?.hourlyWage ?? 0)"
            
            latitude = workPlaceModel?.workPlaceLocation.latitude ?? 37.566691
            longtutude = workPlaceModel?.workPlaceLocation.longitude ?? 126.978365
        }
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtutude) // default position
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapUIView.setRegion(region, animated: true)
        
    }
    
    @IBAction func doSearch(_ sender: Any) {
        let workplaceAddress: String = self.inputTextWorkPlaceAddress.text ?? ""
        if (workplaceAddress.isEmpty) {
            self.showToast(self.view, message: "주소를 입력해 주세요")
        } else {
            self.searchLocation(named: workplaceAddress)
        }
    }
    
    @IBAction func doRegist(_ sender: Any) {
        
        switch self.checkInputField() {
        case 0:
            self.workPlaceModel = WorkPlaceModel(
                workPlaceName: self.inputTextWorkPlaceName.text!,
                workPlaceAddress: self.inputTextWorkPlaceAddress.text!,
                workPlaceLocation: self.location!,
                hourlyWage: Int(self.inputTextHourlyWage.text!)!)
            if(doRegistWorkPlaceData()) {
                showToast(self.view, message: "근무지가 등록 되었습니다.")
                DataManager.shared.currentWorkPlace = self.workPlaceModel
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.navigateToAttendanceCheck()
                }
            }
        case 1:
            showToast(self.view, message: "[Error] 상호가 입력되지 않았습니다.")
            break
        case 2:
            showToast(self.view, message: "[Error] 주소가 입력되지 않았습니다.")
            break
        case 3:
            showToast(self.view, message: "[Error] 시급 정보가 입력되지 않았습니다.")
            break
        case 4:
            showToast(self.view, message: "[Error] 위치가 확인되지 않았습니다.")
            break
        default:
            showToast(self.view, message: "Unknown Error")
        }
    }
    
    private func navigateToAttendanceCheck() {
        if let tabBarController = self.tabBarController,
           let viewControllers = tabBarController.viewControllers,
           let attendanceCheckVC = viewControllers.first(where: { $0 is UINavigationController && ($0 as? UINavigationController)?.viewControllers.first is AttendanceCheckViewController }) as? UINavigationController {
            tabBarController.selectedViewController = attendanceCheckVC
        }
    }
    
    func checkInputField()-> Int {
        if (self.inputTextWorkPlaceName.text!.isEmpty) {
            return 1
        }
        if (self.inputTextWorkPlaceAddress.text!.isEmpty) {
            return 2
        }
        if (self.inputTextHourlyWage.text!.isEmpty) {
            return 3
        }
        if (self.location == nil) {
            return 4
        }
        
        return 0
    }
    
    func searchLocation(named name: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                self.showToast(self.view, message: "Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
           
            // 검색 결과에서 첫 번째 위치를 지도의 중심으로 설정
            let firstLocation = response.mapItems.first?.placemark.coordinate
            if let location = firstLocation {
                let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                annotation.title = name
                
                self.location = location
                self.mapUIView.setRegion(region, animated: true)
                self.mapUIView.addAnnotation(annotation)
            }
        }
    }
    
    /**
            // TODO: implement regist work place data to DB
     */
    func doRegistWorkPlaceData()-> Bool {
        if (isExistWorkPlace) {
            let data = workPlaceModel as AnyObject
            if (dbUtils.writeData(command: .WorkPlace, mode: .update, id: 0, model: data)) {
                return true
            }
        } else {
            let data = workPlaceModel as AnyObject
            if (dbUtils.writeData(command: .WorkPlace, mode: .insert, id: 0, model: data)) {
                return true
            }
        }
        return false
    }
    
    /**
        showToast
     */
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

