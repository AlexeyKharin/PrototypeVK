import UIKit

class ViewController: UIViewController {
    
    var nameCityCountry: String = ""
    
    var viewModel: ViewModelDelegate?
    
    var clousureDailyViewController: ((_ modelDaily: RealmModelDaily,_ nameCity: String) -> Void)?
    
    var clousureHourlyViewController: ((_ modelCurrent: RealmModelCurrent,_ nameCity: String) -> Void)?
    
    private let callContainerView: CallContainerView = {
        let containerView = CallContainerView()
        containerView.toAutoLayout()
        return containerView
    }()
    
    private lazy var callDailyCollectionView: CallDailyCollectionView = {
        let collection = CallDailyCollectionView()
        collection.toAutoLayout()
        collection.delegate = self
        return collection
    }()
    
    private lazy var callHourlyCollecttionView: CallHourlyCollecttionView = {
        let collection = CallHourlyCollecttionView()
        collection.toAutoLayout()
        collection.delegate = self
        return collection
    }()
    
    private var nameCity: String
    
    private var id: String
    
    init(id: String, nameCity: String) {
        self.id = id
        self.nameCity = nameCity
        super.init(nibName: nil, bundle: nil)
    }
    
    func udateCity(nameCity: String) {
        self.nameCity = nameCity
        viewModel?.resultOfRequestGeo(nameCity: self.nameCity, id: self.id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.resultOfRequestGeo(nameCity: self.nameCity, id: self.id)
        viewModel?.obtainsData(id: id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(callContainerView)
        view.addSubview(callHourlyCollecttionView)
        view.addSubview(callDailyCollectionView)
        view.backgroundColor = .white
        viewModel?.resultOfRequestGeo(nameCity: self.nameCity, id: self.id)
        setUp()
        receiveDataFromViewModel()
    }
    
    func receiveDataFromViewModel () {
        
        viewModel?.transferModelDaily = { [weak self] modelDaily in
            self?.callDailyCollectionView.modelDaily = modelDaily
            self?.callContainerView.contentDayNight = modelDaily
            self?.callDailyCollectionView.collectionView.reloadData()
        }
        
        viewModel?.transferModelCurrentHourly = { [weak self] modelHourly in
            self?.callHourlyCollecttionView.realmHourly = modelHourly
            self?.callHourlyCollecttionView.collectionView.reloadData()
            self?.callContainerView.contentCurrent = modelHourly
            
        }
        
        viewModel?.transferNameCountry = { [weak self] text in
            self?.nameCityCountry = text
        }
        
        viewModel?.callAlertError = { [weak self] error in
            switch error {
            case .failedConnect:
                self?.callAlertInError(message: "Для продолжения запроса, проверьте подключение к интернету")
            case .failedDecodeData:
                self?.callAlertInError(message: "Обратитесь в техническую поддержку приложения для восстановления получения данных из сети")
            case .failedGetGeoData:
                self?.callAlertInError(message: "Для продолжения запроса, проверьте подключение к интернету")
            }
        }
    }
    
    private func  callAlertInError(message: String) {
        let alert = UIAlertController(title: "ОШИБКА", message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "ОК", style: .cancel) { _ in
        }
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setUp() {
        
        let constraints = [
            
            callContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            callContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            callContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            callHourlyCollecttionView.topAnchor.constraint(equalTo: callContainerView.bottomAnchor, constant: 33),
            callHourlyCollecttionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            callHourlyCollecttionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            callDailyCollectionView.topAnchor.constraint(equalTo: callHourlyCollecttionView.bottomAnchor, constant: 33),
            callDailyCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            callDailyCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            callDailyCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


//MARK: - delegateOfCallDailyCollectionView
protocol CreateDailySummaryViewController {
    func createDailySummaryViewController(_ modelDaily: RealmModelDaily)
}

extension ViewController: CreateDailySummaryViewController {
    
    func createDailySummaryViewController(_ modelDaily: RealmModelDaily) {
        clousureDailyViewController?(modelDaily, nameCityCountry)
    }
}

//MARK: - delegateOfCallHourlyCollecttionView
protocol CreateHourlyViewController {
    func createHourlyViewController(_ realmHourly: RealmModelCurrent)
}

extension ViewController: CreateHourlyViewController{
    
    func createHourlyViewController(_ realmHourly: RealmModelCurrent) {
        clousureHourlyViewController?(realmHourly, nameCityCountry)
    }
}
