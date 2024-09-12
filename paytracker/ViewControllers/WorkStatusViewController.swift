import UIKit
import CoreLocation

class WorkStatusViewController: UIViewController {
    private var worker: WorkerModel?
    private var workplace: WorkPlaceModel?
    private var workLogs: [WorkLogModel] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let workPeriodLabel = UILabel()
    private let workLogsTableView = UITableView()
    private let totalWageLabel = UILabel()
    
    private let dbUtils = DBUtils.shared
    private let commonUtils = CommonUtils()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WorkStatusViewController viewDidLoad")
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WorkStatusViewController viewWillAppear")
        loadAllData()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("TableView frame: \(workLogsTableView.frame)")
        print("TableView content size: \(workLogsTableView.contentSize)")
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(workPeriodLabel)
        contentView.addSubview(workLogsTableView)
        contentView.addSubview(totalWageLabel)

        workPeriodLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        totalWageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)

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
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            workPeriodLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            workPeriodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            workPeriodLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            workLogsTableView.topAnchor.constraint(equalTo: workPeriodLabel.bottomAnchor, constant: 20),
            workLogsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            workLogsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            workLogsTableView.heightAnchor.constraint(equalToConstant: 400),

            totalWageLabel.topAnchor.constraint(equalTo: workLogsTableView.bottomAnchor, constant: 20),
            totalWageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            totalWageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            totalWageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func loadAllData() {
        loadWorker()
        loadWorkPlace()
        loadWorkLogs()
        print("All data loaded")
    }

    private func loadWorker() {
        worker = dbUtils.readData(command: .Worker) as? WorkerModel
        print("Loaded worker: \(worker?.name ?? "No worker found")")
    }

    private func loadWorkPlace() {
        workplace = dbUtils.readData(command: .WorkPlace) as? WorkPlaceModel
        print("Loaded workplace: \(workplace?.workPlaceName ?? "No workplace found")")
    }

    private func loadWorkLogs() {
        workLogs = dbUtils.readData(command: .WorkLog) as? [WorkLogModel] ?? []
//        workLogs.sort { $0.date > $1.date }  // Sort logs by date, most recent first
        print("Loaded \(workLogs.count) work logs")
        for (index, log) in workLogs.enumerated() {
                print("Log \(index): Date: \(log.date), Start: \(log.startTime), End: \(log.endTime)")
            }
    }

    private func updateUI() {
        let workPeriod = calculateWorkPeriod()
        workPeriodLabel.text = "근무 기간: \(workPeriod)일"
        print("Work period: \(workPeriod) days")

        let totalWage = calculateTotalWage()
        totalWageLabel.text = "총 급여: \(totalWage)원"
        print("Total wage: \(totalWage) won")

        workLogsTableView.reloadData()
        print("Table view reloaded")
    }

    private func calculateWorkPeriod() -> Int {
        return workLogs.count
    }

    private func calculateTotalWage() -> Int {
        guard let hourlyWage = workplace?.hourlyWage else { return 0 }
        
        return workLogs.reduce(0) { totalWage, log in
            let workingTimeInHours = commonUtils.timeDiff(
                start: commonUtils.dateToString(date: log.startTime, format: "HH:mm"),
                end: commonUtils.dateToString(date: log.endTime, format: "HH:mm"))
            return totalWage + (workingTimeInHours * hourlyWage)
        }
    }
}

extension WorkStatusViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called, returning \(workLogs.count)")
        return workLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt called for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkLogCell", for: indexPath)
        let workLog = workLogs[indexPath.row]
        
        let date = commonUtils.dateToString(date: workLog.date, format: "yyyy-MM-dd")
        let startTime = commonUtils.dateToString(date: workLog.startTime, format: "HH:mm")
        let endTime = commonUtils.dateToString(date: workLog.endTime, format: "HH:mm")
        
        let workingTimeInHours = commonUtils.timeDiff(
            start: commonUtils.dateToString(date: workLog.startTime, format: "HH:mm"),
            end: commonUtils.dateToString(date: workLog.endTime, format: "HH:mm"))
        let dailyWage = workingTimeInHours * (workplace?.hourlyWage ?? 0)

        cell.textLabel?.text = "근무일: \(date)\n시간: \(startTime) - \(endTime)\n일급: \(dailyWage)원"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
