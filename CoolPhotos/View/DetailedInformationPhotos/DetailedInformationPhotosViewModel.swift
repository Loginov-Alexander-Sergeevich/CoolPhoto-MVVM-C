//
//  DetailedInformationPhotoViewModel.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit
import SDWebImage

final class DetailedInformationPhotosViewModel {
    
    var delegat: DetailedInformationPhotosCoordinatorProtocol?
    var timer: Timer?
    
    var isFavorite: Bool?
    
    var id = ""
    var nameAuthor = ""
    var dateOfCreation = ""
    var location = ""
    var numberOfDownloads = ""
    var photoUrl = ""
    var realmDBItems: DetailInformationPhotoRealmModel?
    
    var updatePhotoCollection: () -> () = {}
    var updateFaviritePhoto: () -> () = {}
    
    private func convertDateFormat(inputDate: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'-'HH':'mm"
        
        guard let asDate = dateFormater.date(from: inputDate) else { return "Не смог получить дату" }
        
        let formateDate = DateFormatter()
        formateDate.dateFormat = "dd.MM.yyyy"
        
        let asString = formateDate.string(from: asDate)
        
        return asString
    }

    func detailedInformationPhotosViewDidLoad() {
        requestStatisticsPhoto(id: delegat!.resultsRequest.id!)
        photoRequest(data: delegat!.resultsRequest)
        realmDBItems(bd: delegat!.detailInformationPhotoRealmModel)
    }
    
    func requestStatisticsPhoto(id: String) {
        NetworkManadger.shared.requestPhoto(id: id) { [weak self] statistic in
            guard let statistica = statistic?.downloads?.total else { return }

            self?.numberOfDownloads = "Колличество скачиваний - \(statistica)"
            self?.updatePhotoCollection()
        }
    }
    
    func realmDBItems(bd: DetailInformationPhotoRealmModel) {
        self.realmDBItems = bd
        self.updateFaviritePhoto()
    }
    
    func photoRequest(data: PhotoSearchResultsRequest) {
        let date = convertDateFormat(inputDate: data.created_at)
        
        guard let lastName = data.user.lastName, let firstName = data.user.firstName, let photoUrl = data.urls["regular"] else {return}
        
        self.nameAuthor = "Автор - \(lastName + " " + firstName)"
        self.photoUrl = photoUrl!
        self.dateOfCreation = "Дата создания - \(date)"
        self.location = "Место положение - \(data.user.location ?? "Неизвестно")"
        self.id = data.id ?? "1"
    }
    


    func saveDataInRealmBD() {
        
        guard let photoUrl = self.delegat?.resultsRequest.urls["regular"] else {return}
        self.photoUrl = photoUrl!
        
        RealmManadger.shared.addItem(photoUrl: photoUrl ?? "",
                                    nameAvtor: self.nameAuthor,
                                    creatDate: self.dateOfCreation,
                                    location: self.location,
                                    numberOfDownloads: self.numberOfDownloads)
    }
    
    func deletDataInRealmBD() {
        RealmManadger.shared.deleteItem(at: delegat!.detailInformationPhotoRealmModel._id)
    }
}


