import UIKit

class DailySummaryViewController: UIViewController {
    
    private var switchedIndex: Int = 0
    
    private let customNavigationBar = UINavigationBar()
    
    private let customNavigationController: UINavigationController
    
    private var modelUINight: [UIModelNightDayTableViewCell]
    
    private var modelUIDay: [UIModelNightDayTableViewCell]
    
    private var modelUIHeader: [UIModelCollectionHeaderCell]
    
    private var modelUIDayNight: [UIModelSunAndMoonСell]
    
    init(realmModelDaily: RealmModelDaily, titleCity: String, customNavigationController: UINavigationController) {
        
        self.modelUIDay = realmModelDaily.weatherDaily.map { UIModelNightDayTableViewCell(weatherDescription: $0.weatherDescription, uviValue: $0.uvi, rainValue: $0.pop, imageCondition: $0.imageCondition, cloudyValue: $0.clouds, temp: $0.tempDay, feelLikesValue: $0.feelsLikeDay, windSpeedValue: $0.windSpeed) }
        
        self.modelUINight = realmModelDaily.weatherDaily.map { UIModelNightDayTableViewCell(weatherDescription: $0.weatherDescription, uviValue: $0.uvi, rainValue: $0.pop, imageCondition: $0.imageCondition, cloudyValue: $0.clouds, temp: $0.tempNight, feelLikesValue: $0.feelsLikeNight, windSpeedValue: $0.windSpeed) }
        
        self.modelUIHeader = realmModelDaily.weatherDaily.map { UIModelCollectionHeaderCell(dataForCollection: $0.dataForCollection) }
        
        self.modelUIDayNight = realmModelDaily.weatherDaily.map { UIModelSunAndMoonСell(sunsetValue: $0.sunset, sunriseValue: $0.sunrise, moonsetValue: $0.moonset, moonriseValue: $0.moonrise) }
        
        self.titleCity.text = titleCity
        self.customNavigationController = customNavigationController
        super.init(nibName: nil, bundle: nil)
    }
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.toAutoLayout()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DaySummaryTableViewCell.self, forCellReuseIdentifier: String(describing: DaySummaryTableViewCell.self))
        tableView.register(CollectionHeaderForSectionOne.self, forHeaderFooterViewReuseIdentifier: String(describing: CollectionHeaderForSectionOne.self))
        tableView.register(NightSummaryTableViewCell.self, forCellReuseIdentifier: String(describing: NightSummaryTableViewCell.self))
        tableView.register(SunAndMoonСell.self, forCellReuseIdentifier: String(describing: SunAndMoonСell.self))
        
        return tableView
    }()
    
    let backTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 154/255, green: 150/255, blue: 150/255, alpha: 1)
        label.text = "Дневная погода"
        label.textAlignment = .left
        return label
    }()
    
    let titleCity: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 39/255, green: 39/255, blue: 34/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward")!.applyingSymbolConfiguration(.init(scale: .large))! .withTintColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)).withRenderingMode(.alwaysOriginal), for:.normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return button
    }()
    
    @objc func back() {
        customNavigationController.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        buttonBack.frame = CGRect(
            x: 16,
            y: 34,
            width: 15,
            height: 12)
        
        backTitle.frame = CGRect(
            x: buttonBack.frame.maxX + 20,
            y: 30,
            width: 200,
            height: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customNavigationBar)
        customNavigationBar.addSubview(buttonBack)
        customNavigationBar.addSubview(backTitle)
        view.addSubview(titleCity)
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        customNavigationBar.frame = CGRect(
            x: .zero,
            y: 44,
            width: self.view.bounds.width,
            height: 50)
        
        let constraints = [
            titleCity.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 15),
            titleCity.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            titleCity.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            tableView.topAnchor.constraint(equalTo: titleCity.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//    MARK:- UITableViewDataSource
extension DailySummaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: NightSummaryTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: NightSummaryTableViewCell.self),
                for: indexPath) as! NightSummaryTableViewCell
            let content = modelUINight[switchedIndex]
            cell.contentNight = content
            return cell
            
        case 1:
            let cell: DaySummaryTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: DaySummaryTableViewCell.self),
                for: indexPath) as! DaySummaryTableViewCell
            let content = modelUIDay[switchedIndex]
            cell.contentDay = content
            return cell
            
        default:
            let cell: SunAndMoonСell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SunAndMoonСell.self),
                for: indexPath) as! SunAndMoonСell
            cell.contentDay = modelUIDayNight[switchedIndex]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: CollectionHeaderForSectionOne.self) ) as! CollectionHeaderForSectionOne
            
            headerView.contentDaily = modelUIHeader
            
            headerView.dataTransferInt = { index in
                self.switchedIndex = index
                self.tableView.reloadData()
            }
            return headerView
            
        default:
            let view = UIView()
            view.backgroundColor = .white
            return view
            
        }
    }
}

//    MARK: - UITableViewDelegate
extension DailySummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 76
        default:
            return 12
        }
    }
}


