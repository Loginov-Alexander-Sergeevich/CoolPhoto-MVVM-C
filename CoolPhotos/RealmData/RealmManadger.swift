//
//  RealmManadger.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import RealmSwift

final class RealmManadger {

    static let shared = RealmManadger()
    private init(){}

    let realm = try! Realm()
    var detailInformationPhotoRealmModel: Results<DetailInformationPhotoRealmModel>!
    
    func items() -> [DetailInformationPhotoRealmModel] {
        detailInformationPhotoRealmModel = realm.objects(DetailInformationPhotoRealmModel.self)
        let items = self.detailInformationPhotoRealmModel
        return Array(items!)
    }
    
    
    func addItem(photoUrl: String, nameAvtor: String, creatDate: String, location: String, numberOfDownloads: String) {
        
        let item = DetailInformationPhotoRealmModel(photoUrl: photoUrl, nameAvtor: nameAvtor, creatDate: creatDate, location: location, numberOfDownloads: numberOfDownloads)
        
        do {
            try self.realm.write{
                self.realm.add(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func deleteItem(at id: ObjectId) {
        
        detailInformationPhotoRealmModel = realm.objects(DetailInformationPhotoRealmModel.self)
        
        if let objct = detailInformationPhotoRealmModel.filter("_id = %@", id as Any).first {
            try! realm.write {
                realm.delete(objct)
            }
        }
    }
}
