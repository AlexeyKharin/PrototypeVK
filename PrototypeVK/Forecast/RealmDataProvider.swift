import Foundation
import RealmSwift

class RealmDataProvider {
    
    func save(modelHourly: RealmModelCurrent)  {
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write {
                realm.add(modelHourly, update: .all)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func save(modelDaily: RealmModelDaily)  {
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write {
                realm.add(modelDaily, update: .all)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func obtainDailyModel()  -> [RealmModelDaily] {
        var  modelsObject = [RealmModelDaily]()
        
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            let models = realm.objects(RealmModelDaily.self)
            modelsObject = Array(models)
        } catch {
            fatalError("ОШИБКА")
        }
        return modelsObject
    }
    
    func obtainModelCurrent()  -> [RealmModelCurrent] {
        var  modelsObject = [RealmModelCurrent]()
        
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            let models = realm.objects(RealmModelCurrent.self)
            modelsObject = Array(models)
        } catch {
            fatalError("ОШИБКА")
        }
        return modelsObject
    }
}
