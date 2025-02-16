//
//  PersonListViewModel.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//

import Foundation
import UIKit
import SwiftUI

import RealmSwift

class PersonListViewModel: ObservableObject {
    
    @Published var personList: [PersonModel] = []
    @Published var searchPersonText: String = ""
    @Published var showFormView: Bool = false
    
    var editPerson: PersonModel?
    
    var filteredPersons: [PersonModel] {
        if searchPersonText.isEmpty {
            return personList  
        } else {
            return personList.filter { person in
                let fullName = "\(person.firstName) \(person.lastName)".lowercased()
                return fullName.contains(searchPersonText.lowercased())
            }
        }
    }
    
    private let databaseManager: DatabaseManager
    
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    func getPersonsList() {
        DispatchQueue.main.async {
            self.personList = self.databaseManager.fetchAll(PersonModel.self)
        }
    }
    
    func returnPersonImage(_ profilePath: String) -> Image {
        
        guard let image = databaseManager.fetchImageFromFileSystem(path: profilePath) else {
            return Image("useProfileImage")
        }
        
        return Image(uiImage: image)
        
    }
    
    func fullAddress(_ person: PersonModel) -> String {
        
        var address = ""
        
        guard let primaryAddress = person.addressList.first else {
            return address
        }
        
        address = "\(primaryAddress.houseNo) \(primaryAddress.area) \(primaryAddress.pinCode) \(primaryAddress.city) \(primaryAddress.state)"
        
        return address
    }
    
    func fullEducation(_ person: PersonModel) -> (stream: String, duration: String, location: String) {
        
        guard let primaryEducation = person.educationList.first else {
            return ("", "", "")
        }

        return (primaryEducation.stream,"\(primaryEducation.startYear)-\(primaryEducation.endYear)","\(primaryEducation.collageName)")
    }
    
    func searchPerson(_ name: PersonModel) {
        
    }
    
}
