//import UIKit
//import CoreLocation
//
//class SettingsViewController: UIViewController {
//    // MARK: - Properties
//    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
//    private var workerModel: WorkerModel?
//    private var workPlaceModel: WorkPlaceModel?
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadData()
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        title = "설정"
//        view.backgroundColor = .systemBackground
//        
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
//    }
//    
//    // MARK: - Data Loading
//    private func loadData() {
//        // TODO: Load actual data from your data source
//        workerModel = WorkerModel(name: "홍길동", email: "hong@example.com")
//        workPlaceModel = WorkPlaceModel(workPlaceName: "카페", workPlaceAddress: "서울시 강남구", workPlaceLocation: CLLocationCoordinate2D(latitude: 37.5, longitude: 127.0), hourlyWage: 9160)
//        tableView.reloadData()
//    }
//}
//
//// MARK: - UITableViewDelegate, UITableViewDataSource
//extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 2 : 5
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return section == 0 ? "내 정보" : "근무지 정보"
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
//        cell.accessoryType = .disclosureIndicator
//        
//        if indexPath.section == 0 {
//            switch indexPath.row {
//            case 0:
//                cell.textLabel?.text = "이름: \(workerModel?.name ?? "")"
//            case 1:
//                cell.textLabel?.text = "이메일: \(workerModel?.email ?? "")"
//            default:
//                break
//            }
//        } else {
//            switch indexPath.row {
//            case 0:
//                cell.textLabel?.text = "상호명: \(workPlaceModel?.workPlaceName ?? "")"
//            case 1:
//                cell.textLabel?.text = "주소: \(workPlaceModel?.workPlaceAddress ?? "")"
//            case 2:
//                cell.textLabel?.text = "시급: \(workPlaceModel?.hourlyWage ?? 0)원"
//            case 3:
//                cell.textLabel?.text = "근무 일자"
//            case 4:
//                cell.textLabel?.text = "근무 시간"
//            default:
//                break
//            }
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // TODO: 각 항목 선택 시 수정 화면으로 이동
//        let editVC = EditSettingsViewController(type: indexPath.section == 0 ? .workerInfo : .workplaceInfo, row: indexPath.row)
//        navigationController?.pushViewController(editVC, animated: true)
//    }
//}
//
//class EditSettingsViewController: UIViewController {
//    enum EditType {
//        case workerInfo
//        case workplaceInfo
//    }
//    
//    private let editType: EditType
//    private let row: Int
//    private let textField = UITextField()
//    
//    init(type: EditType, row: Int) {
//        self.editType = type
//        self.row = row
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        title = "정보 수정"
//        
//        view.addSubview(textField)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.borderStyle = .roundedRect
//        
//        NSLayoutConstraint.activate([
//            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            textField.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
//        
//        // Set placeholder and current value based on the edit type and row
//        switch editType {
//        case .workerInfo:
//            textField.placeholder = row == 0 ? "이름" : "이메일"
//            // TODO: Set current value
//        case .workplaceInfo:
//            switch row {
//            case 0:
//                textField.placeholder = "상호명"
//            case 1:
//                textField.placeholder = "주소"
//            case 2:
//                textField.placeholder = "시급"
//                textField.keyboardType = .numberPad
//            case 3:
//                textField.placeholder = "근무 일자"
//            case 4:
//                textField.placeholder = "근무 시간"
//            default:
//                break
//            }
//            // TODO: Set current value
//        }
//    }
//    
//    @objc private func saveButtonTapped() {
//        // TODO: Save the updated information
//        navigationController?.popViewController(animated: true)
//    }
//}
