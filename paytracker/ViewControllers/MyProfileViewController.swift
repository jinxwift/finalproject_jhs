import UIKit
import CoreLocation

class MyProfileViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var workerModel: WorkerModel?
    private var workPlaceModel: WorkPlaceModel?
    
    private let dbUtils = DBUtils.shared
    
    private let generateDummyDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Test Data", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupGenerateDummyDataButton()
    }
    
    private func setupUI() {
        title = "내 정보"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileInfoCell.self, forCellReuseIdentifier: "ProfileInfoCell")
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
    }
    
    private func setupGenerateDummyDataButton() {
        view.addSubview(generateDummyDataButton)
        NSLayoutConstraint.activate([
            generateDummyDataButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            generateDummyDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateDummyDataButton.widthAnchor.constraint(equalToConstant: 200),
            generateDummyDataButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        generateDummyDataButton.addTarget(self, action: #selector(generateTestDataTapped), for: .touchUpInside)
        
    }
    
    @objc private func generateTestDataTapped() {
        DummyDataGenerator.shared.generateCompleteTestScenario()
        showAlert(message: "Complete test scenario data generated successfully")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Debug", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func loadData() {
        workerModel = dbUtils.readData(command: .Worker) as? WorkerModel
        workPlaceModel = dbUtils.readData(command: .WorkPlace) as? WorkPlaceModel
        tableView.reloadData()
    }
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "내 정보" : "근무지 정보"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as? ProfileInfoCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.configure(with: "이름", value: workerModel?.name ?? "정보 없음", icon: "person.fill")
            case 1:
                cell.configure(with: "이메일", value: workerModel?.email ?? "정보 없음", icon: "envelope.fill")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.configure(with: "상호명", value: workPlaceModel?.workPlaceName ?? "정보 없음", icon: "building.2.fill")
            case 1:
                cell.configure(with: "주소", value: workPlaceModel?.workPlaceAddress ?? "정보 없음", icon: "mappin.circle.fill")
            case 2:
                cell.configure(with: "시급", value: "\(workPlaceModel?.hourlyWage ?? 0)원", icon: "wonsign.circle.fill")
            default:
                break
            }
        }
        
        cell.applyRoundedCorners(isFirst: indexPath.row == 0, isLast: indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ProfileInfoCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with title: String, value: String, icon: String) {
        titleLabel.text = title
        valueLabel.text = value
        iconImageView.image = UIImage(systemName: icon)
    }
    
    func applyRoundedCorners(isFirst: Bool, isLast: Bool) {
        containerView.layer.cornerRadius = 10
        containerView.layer.maskedCorners = []
        
        if isFirst {
            containerView.layer.maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if isLast {
            containerView.layer.maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        
        containerView.layer.masksToBounds = true
    }
}
