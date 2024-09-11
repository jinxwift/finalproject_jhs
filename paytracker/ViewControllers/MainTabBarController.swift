//
//  MainTabBarController.swift
//  paytracker
//
//  Created by Jude Song on 8/29/24.
//

import UIKit
import CoreLocation

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 출퇴근 (Attendance Check)
        let attendanceVC = storyboard.instantiateViewController(withIdentifier: "AttendanceCheckViewController")
        let attendanceNavController = UINavigationController(rootViewController: attendanceVC)
        attendanceVC.tabBarItem = UITabBarItem(title: "출퇴근", image: UIImage(systemName: "person.crop.circle.badge.checkmark"), tag: 0)
        
        // 근무 현황 (Work Status)
        let workStatusVC = WorkStatusViewController(worker: WorkerModel(name: "테스트 사용자", email: "test@example.com"), workplace: WorkPlaceModel(workPlaceName: "", workPlaceAddress: "", workPlaceLocation: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), hourlyWage: 0))
        let workStatusNavController = UINavigationController(rootViewController: workStatusVC)
        workStatusVC.tabBarItem = UITabBarItem(title: "근무 현황", image: UIImage(systemName: "clock"), tag: 1)
        
        // 근무지 (Work Place)
        let workPlaceVC = storyboard.instantiateViewController(withIdentifier: "vc_work_place")
        let workPlaceNavController = UINavigationController(rootViewController: workPlaceVC)
        workPlaceVC.tabBarItem = UITabBarItem(title: "근무지", image: UIImage(systemName: "mappin.and.ellipse"), tag: 2)
        
        // 설정 (Settings)
        let settingsVC = SettingsViewController()
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        settingsVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 3)

        viewControllers = [attendanceNavController, workStatusNavController, workPlaceNavController, settingsNavController]
    }
}
