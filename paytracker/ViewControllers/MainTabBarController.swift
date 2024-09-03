//
//  MainTabBarController.swift
//  paytracker
//
//  Created by Jude Song on 8/29/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "메인", image: UIImage(systemName: "house"), tag: 0)
        
        let workStatusVC = WorkStatusViewController(worker: WorkerModel(name: "테스트 사용자", email: "test@example.com"))
        workStatusVC.tabBarItem = UITabBarItem(title: "근무 현황", image: UIImage(systemName: "clock"), tag: 1)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 2)

        viewControllers = [mainVC, workStatusVC, settingsVC].map { UINavigationController(rootViewController: $0) }
    }
}
