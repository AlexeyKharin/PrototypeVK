
import Foundation
import UIKit

protocol ViewModelDelegate {
    
    var transferModelDaily: ((RealmModelDaily) -> Void)? { get set }
    
    var transferModelCurrentHourly: ((RealmModelCurrent) -> Void)? { get set }
    
    func obtainsData(id: String)
    
    func resultOfRequestGeo(nameCity: String, id: String)
    
    var transferNameCountry: ((String) -> Void)? { get set }
    
    var callAlertError: ((ObtainError) -> Void)? { get set }
}

class ViewModel: ViewModelDelegate {
    
    var realm: RealmDataProvider?
    
    var convert: ConverterModelData?
    
    var transferModelDaily: ((RealmModelDaily) -> Void)?
    
    var transferModelCurrentHourly: ((RealmModelCurrent) -> Void)?
    
    var transferNameCity: ((String) -> Void)?
    
    var transferNameCountry: ((String) -> Void)?
    
    var callAlertError: ((ObtainError) -> Void)?
    
    private var modelCurrentHourly = RealmModelCurrent()  {
        didSet {
            transferModelCurrentHourly?(modelCurrentHourly)
        }
    }
    
    private var modelDaily: RealmModelDaily = RealmModelDaily() {
        didSet {
            transferModelDaily?(modelDaily)
        }
    }
    
    func resultOfRequestGeo(nameCity: String, id: String) {
        let apiGeoUrl = ApiType.geographicData(nameCity).request
        
        NetworkManager.obtainGeoData(url: apiGeoUrl)  { [self] (result) in
            switch result {
            case .success(let data):
                let latAndLon = data.response?.geoObjectCollection?.featureMember?.first?.geoObject?.point?.pos ?? ""
                let parts = latAndLon.split(separator: " ")
                let longitude = Double(parts[0])
                let latitude = Double(parts[1])
                
                resultOfRequesDaily(id: id, latitude: latitude!, longitude: longitude!)
                resultOfRequesHourly(nameCity: nameCity, id: id, latitude: latitude!, longitude: longitude!)
                
                guard let nameCountry = data.response?.geoObjectCollection?.featureMember?.first?.geoObject?.metaDataProperty?.geocoderMetaData?.text else { return }
                transferNameCountry?(nameCountry)
                
            case .failure(let error):
                obtainsData(id: id)
                callAlertError?(error)
                print(error.localizedDescription)
            }
        }
    }
    
    func obtainsData(id: String)  {
        guard let modelCurrentHourly =  realm?.obtainModelCurrent().first(where: { $0.id == id }) else { return }
        self.modelCurrentHourly = modelCurrentHourly
        
        guard let modelDaily =  realm?.obtainDailyModel().first(where: { $0.id == id }) else { return }
        self.modelDaily = modelDaily
    }
    
    private func resultOfRequesDaily(id: String, latitude: Double, longitude: Double) {
        let apiDailyUrl = ApiType.getDaily(latitude, longitude).request
        
        NetworkManager.obtainDailyData(url: apiDailyUrl) { [self] (result) in
            switch result {
            case .success(let data):
                let model = convert?.convertDailyModel(modelDaily: data, id: id)
                realm?.save(modelDaily: model!)
                obtainsData(id: id)
                
            case .failure(let error):
                obtainsData(id: id)
                callAlertError?(error)
            }
        }
    }
    
    private func resultOfRequesHourly(nameCity: String, id: String, latitude: Double, longitude: Double) {
        let apiHourlyUrl = ApiType.getHourly(latitude, longitude).request
        
        NetworkManager.obtainHourlyData(url: apiHourlyUrl) { [self] (result) in
            switch result {
            case .success(let data):
                let model = convert?.convertHourlyModel(modelHourly: data, id: id)
                model?.nameCity = nameCity
                realm?.save(modelHourly: model!)
                obtainsData(id: id)
                
            case .failure(let error):
                obtainsData(id: id)
                callAlertError?(error)
            }
        }
    }
}

