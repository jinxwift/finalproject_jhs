import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "메인"
        
        // Add a welcome label as an example
        let welcomeLabel = UILabel()
        welcomeLabel.text = "PayTracker에 오신 것을 환영합니다!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        welcomeLabel.textColor = .label
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
