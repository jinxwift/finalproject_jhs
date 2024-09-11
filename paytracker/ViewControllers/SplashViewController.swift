import UIKit

class SplashViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        let image = UIImage(systemName: "clock.fill", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PayTracker"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dbUtils = DBUtils()
    private var userCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpDatabase()
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkUserInfo()
        }
    }
    
    private func setUpDatabase() {
        _ = dbUtils.createTable(command: .Worker)
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func checkUserInfo() {
        let workerData = dbUtils.readData(command: .Worker) as! WorkerModel
        
//        let userDefaults = UserDefaults.standard
//        let userExists = userDefaults.bool(forKey: "UserInfoSaved")
        
        if (workerData.name.isEmpty && workerData.email.isEmpty) {
            navigateToUserInfo()
        } else {
            navigateToMainTabBar()
        }
    }
    
    private func navigateToUserInfo() {
        let userInfoVC = UserInfoViewController()
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    private func navigateToMainTabBar() {
        let mainTabBarController = MainTabBarController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
        }
    }
}
