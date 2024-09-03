import UIKit
import CoreLocation

class WorkStatusViewController: UIViewController {
    private let worker: WorkerModel
    private var workLogs: [WorkLogModel] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let workPeriodLabel = UILabel()
    private let workLogsTableView = UITableView()
    private let totalWageLabel = UILabel()

    init(worker: WorkerModel) {
        self.worker = worker
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        setupConstraints()
        loadWorkLogs()
        updateUI()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(workPeriodLabel)
        contentView.addSubview(workLogsTableView)
        contentView.addSubview(totalWageLabel)

        workLogsTableView.dataSource = self
        workLogsTableView.delegate = self
        workLogsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WorkLogCell")
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        workPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        workLogsTableView.translatesAutoresizingMaskIntoConstraints = false
        totalWageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            workPeriodLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            workPeriodLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            workPeriodLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),

            workLogsTableView.topAnchor.constraint(equalTo: workPeriodLabel.bottomAnchor, constant: 20),
            workLogsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            workLogsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            workLogsTableView.heightAnchor.constraint(equalToConstant: 300),

            totalWageLabel.topAnchor.constraint(equalTo: workLogsTableView.bottomAnchor, constant: 20),
            totalWageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            totalWageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            totalWageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func loadWorkLogs() {
        // 여기서 실제 데이터 로드. 지금은 더미.
        workLogs = [
            WorkLogModel(
                date: Date(),
                startTime: Date(),
                endTime: Date(),
                startPosition: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                endPosition: CLLocationCoordinate2D(latitude: 0, longitude: 0), 
                workPlace: WorkPlaceModel(workPlaceName: "Test", workPlaceAddress: "Test Address", workPlaceLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0), hourlyWage: 10000))
        ]
    }

    private func updateUI() {
        let workPeriod = calculateWorkPeriod()
        workPeriodLabel.text = "근무 기간: \(workPeriod)일"

        let totalWage = calculateTotalWage()
        totalWageLabel.text = "총 급여: \(totalWage)원"

        workLogsTableView.reloadData()
    }

    private func calculateWorkPeriod() -> Int {
        // 실제 계산 로직
        return workLogs.count
    }

    private func calculateTotalWage() -> Int {
        // 실제 계산 로직
        return workLogs.reduce(0) { $0 + $1.workPlace.hourlyWage }
    }
}

extension WorkStatusViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath)
        let workLog = workLogs[indexPath.row]

        cell.textLabel?.text = "Date: \(workLog.date), Wage: \(workLog.workPlace.hourlyWage)원"

        return cell
    }
}
