import UIKit

class UserInfoViewController: UIViewController {
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("제출", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        initDataBase()
        setupUI()
        loadExistingData()
    }
    
    private let dbUtils = DBUtils.shared
    private var userCount: Int = 0
    
    private func initDataBase() {
        if (dbUtils.createTable(command: .Worker)) {
            print("OK")
        } else {
            print("Error")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func loadExistingData() {
        let workerData = dbUtils.readData(command: .Worker) as! WorkerModel
        
        if (workerData.name.isEmpty && workerData.email.isEmpty) {
            userCount = 0
        } else {
            userCount = 1
            nameTextField.text = workerData.name
            emailTextField.text = workerData.email
        }
        
//        if let name = UserDefaults.standard.string(forKey: "userName") {
//            nameTextField.text = name
//        }
//        if let email = UserDefaults.standard.string(forKey: "userEmail") {
//            emailTextField.text = email
//        }
    }
    
    @objc private func submitButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "빈칸을 채워주세요.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(message: "유효한 이메일을 입력해 주세요.")
            return
        }
        
        // Save user info
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(true, forKey: "userInfoSaved")
        
        let worker = WorkerModel(name: name, email: email)
        var mode: DBUtils.Mode = .none
        
        if (userCount == 0) {
            mode = .insert
        } else {
            mode = .update
        }
        if (dbUtils.writeData(command: .Worker, mode: mode, id: 0, model: worker as AnyObject)) {
            print("[UserInfoVC] DB transaction OK")
            navigateToMainTabBar()
        } else {
            print("[UserInfoVC] DB transaction ERROR")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

//for git push
