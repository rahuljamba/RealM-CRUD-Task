//
//  PersonFormViewModel.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//

import Foundation
import UIKit
import SwiftUI

class PersonFormViewModel: ObservableObject {
    
    @Published var personalDetailsFields: [PersonDetailModel] = AppConstant.personalDetail()
    @Published var addressDetailsFields: [[PersonDetailModel]] = [AppConstant.addressForm()]
    @Published var educationDetailsFields: [[PersonDetailModel]] = [AppConstant.educationForm()]
    
    @Published var mobileFields: Int = 1
    @Published var showActionSheet: Bool = false
    @Published var showPresentSheet: Bool = false
    @Published var selectedProfileImage: UIImage? = .init(named: "defaultProfileBg")
    
    @Published var isTextFieldEmpty: Bool = false
    
    var editPerson: PersonModel?
    let updatedPersonModel = PersonModel()
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    private let databaseManager: DatabaseManager
    
    init(_ databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    func addMore(_ formType: PersonFormType) {
        switch formType {
            case .personalDetail:
                addMoreMobileField()
                return
            case .address:
                addMoreAddressForm()
                return
            case .education:
                addMoreEducationForm()
                return
        }
    }
    
    func deleteMore<T: PersonDetailModelProtocol>(_ formType: PersonFormType, deleteItem: T)  {
        deleteMobileField(deleteItem)
    }
    
    func deleteMore(_ formType: PersonFormType, deleteIndex: Int)  {
        
        if formType == .address {
            deleteMoreAddressForm(deleteIndex)
        }
        
        if formType == .education {
            deleteMoreEducationForm(deleteIndex)
        }
        
    }
    
    deinit {
        editPerson = nil
        clearAllFields()
    }
    
}

//MARK: More mobile field

extension PersonFormViewModel {
    
    private func addMoreMobileField() {
        mobileFields += 1
        let newMobileField: PersonDetailModel = .init(label: "Mobile No.", fieldNNumber: mobileFields, placeHolderText: "Enter your mobile No.", inputText: "")
        personalDetailsFields.append(newMobileField)
    }
    
    private func deleteMobileField<T: PersonDetailModelProtocol>(_ personalDetail: T) {
        guard let index = personalDetailsFields.firstIndex(where: { $0.fieldNNumber == personalDetail.fieldNNumber }) else { return }
        
        mobileFields -= 1
        personalDetailsFields.remove(at: index)
    }
}

extension PersonFormViewModel {
    
    private func addMoreAddressForm() {
        var addNewAddressForm = AppConstant.addressForm()
        addNewAddressForm[0].inputText = "asas"
        addressDetailsFields.append(addNewAddressForm)
    }
 
    private func deleteMoreAddressForm(_ deleteIndex: Int) {
        addressDetailsFields.remove(at: deleteIndex)
    }
    
}

extension PersonFormViewModel {
    
    private func addMoreEducationForm() {
        let addNewEducationForm = AppConstant.educationForm()
        educationDetailsFields.append(addNewEducationForm)
    }
    
    private func deleteMoreEducationForm(_ deleteIndex: Int) {
        educationDetailsFields.remove(at: deleteIndex)
    }
}

extension PersonFormViewModel {
    
    func submitInformation() {
        
        if isEditProfile() {
            savePersonInformation()
        }else {
            updatePersonInformation()
            
        }
    }
    
    func updatePersonInformation() {
        
        if let image = selectedProfileImage, let imagePath = databaseManager.saveImageToFileSystem(image: image, name: "\(editPerson?.firstName ?? "")_\(editPerson?.lastName ?? "")") {
            updatedPersonModel.profilePicture = imagePath
        }
        
        updatedPersonModel.firstName =  personalDetailsFields[0].inputText
        updatedPersonModel.lastName  =  personalDetailsFields[1].inputText
        updatedPersonModel.dob =        personalDetailsFields[2].inputText
        
        updatedPersonModel.mobileNumbers.append(objectsIn: personalDetailsFields.compactMap(\.inputText))
        
        addressDetailsFields.forEach { addressList in
        
            let updatedAddress = AddressModel()
            
            addressList.forEach { personModel in
                
                if personModel.label == "House no, flat, building, apartment" {
                    updatedAddress.houseNo = personModel.inputText
                }
                
                if personModel.label == "Area, street, sector, village" {
                    updatedAddress.area = personModel.inputText
                }
                
                if personModel.label == "Pin code" {
                    updatedAddress.pinCode = personModel.inputText
                }
                
                if personModel.label == "Town/City" {
                    updatedAddress.city = personModel.inputText
                }
                
                if personModel.label == "State" {
                    updatedAddress.state = personModel.inputText
                }
                
                updatedPersonModel.addressList.append(updatedAddress)
                
            }
        }
        
        educationDetailsFields.forEach { educationModel in
            
            let education = EducationModel()
            
            educationModel.forEach { personModel in
                
                if personModel.label == "Level" {
                    education.level = personModel.inputText
                }
                
                if personModel.label == "Stream" {
                    education.stream = personModel.inputText
                }
                
                if personModel.label == "Start year" {
                    education.startYear = personModel.inputText
                }
                
                if personModel.label == "End year" {
                    education.endYear = personModel.inputText
                }
                
                if personModel.label == "Institute/Collage name" {
                    education.collageName = personModel.inputText
                }
                
                updatedPersonModel.educationList.append(education)
                
            }
        }
        
        editPerson = nil
        editPerson = updatedPersonModel
        
        guard let editModel = editPerson else { return }
        
        databaseManager.updateObject(ofType: PersonModel.self, byId: editModel.id, update: updatedPersonModel) { status in
            clearAllFields()
        }
        
    }
    
    func savePersonInformation() {
        
        isTextFieldEmpty = isAllPersonFieldEmpty()
        
        if isTextFieldEmpty {
            return
        }
        
        let personModel = PersonModel()
        
        personModel.firstName =  personalDetailsFields[0].inputText
        personModel.lastName =  personalDetailsFields[1].inputText
        personModel.dob =  personalDetailsFields[2].inputText
        
        if let profileImage = selectedProfileImage, let imagePath = databaseManager.saveImageToFileSystem(image: profileImage, name: "\(personModel.firstName)_\(personModel.lastName)") {
            
            personModel.profilePicture = imagePath
            print("imagePath \(imagePath)")
            
        }
        
        let mobileNumbers:[String] = personalDetailsFields.filter { $0.label == "Mobile No." }.map { $0.inputText }
        personModel.mobileNumbers.append(objectsIn: mobileNumbers)
        
        var addressList = [AddressModel]()
        
        addressDetailsFields.forEach { addressDetail in
            
            let list = addressDetail.map(\.inputText)
            
            let address = AddressModel()
            
            address.houseNo = list[0]
            address.area = list[1]
            address.pinCode = list[2]
            address.city = list[3]
            address.state = list[4]
            
            addressList.append(address)
        }
        
        var educationList = [EducationModel]()
        
        educationDetailsFields.forEach { educationDetail in
            
            let list = educationDetail.map(\.inputText)
            
            let education = EducationModel()
            
            education.level = list[0]
            education.stream = list[1]
            education.startYear = list[2]
            education.endYear = list[3]
            education.collageName = list[4]
            
            educationList.append(education)
        }
        
        personModel.addressList.append(objectsIn: addressList)
        personModel.educationList.append(objectsIn: educationList)
        databaseManager.save(personModel) { status in
            if status {
                clearAllFields()
            }
        }
    }
    
    func editPerson(_ person: PersonModel?) {

        editPerson = person
        guard let updatePerson = editPerson else { return }

        selectedProfileImage = databaseManager.fetchImageFromFileSystem(path: updatePerson.profilePicture ?? "")
        
        personalDetailsFields[0].inputText = updatePerson.firstName
        personalDetailsFields[1].inputText = updatePerson.lastName
        personalDetailsFields[2].inputText = updatePerson.dob
        personalDetailsFields[3].inputText = updatePerson.mobileNumbers.first!
        
        for index in 1..<updatePerson.mobileNumbers.count {
            let mobileNo = updatePerson.mobileNumbers[index]
            let newMobileField: PersonDetailModel = .init(label: "Mobile No.", fieldNNumber: mobileFields, placeHolderText: "Enter your mobile No.", inputText: mobileNo)
            personalDetailsFields.append(newMobileField)
        }
        
        var fullAddressList = [[PersonDetailModel]]()
        
        for index in 0..<updatePerson.addressList.count {
            
            var newForm: [PersonDetailModel] = AppConstant.addressForm()
            let savedAddress = updatePerson.addressList[index]
            
            for formIndex in 0..<newForm.count {

                if newForm[formIndex].label == "House no, flat, building, apartment" {
                    newForm[formIndex].inputText = savedAddress.houseNo
                }
                
                if newForm[formIndex].label == "Area, street, sector, village" {
                    newForm[formIndex].inputText = savedAddress.area
                }
                
                if newForm[formIndex].label == "Pin code" {
                    newForm[formIndex].inputText = savedAddress.pinCode
                }
                
                if newForm[formIndex].label == "Town/City" {
                    newForm[formIndex].inputText = savedAddress.city
                }
                
                if newForm[formIndex].label == "State" {
                    newForm[formIndex].inputText = savedAddress.state
                }
            }
            
            fullAddressList.append(newForm)
            
        }
        
        addressDetailsFields.removeAll()
        addressDetailsFields.append(contentsOf: fullAddressList)
        
        var fullEducationList = [[PersonDetailModel]]()
        
        for index in 0..<updatePerson.educationList.count {
            
            var newForm: [PersonDetailModel] = AppConstant.educationForm()
            let savedEducation = updatePerson.educationList[index]
            
            for formIndex in 0..<newForm.count {
                
                if newForm[formIndex].label == "Level" {
                    newForm[formIndex].inputText = savedEducation.level
                }
                
                if newForm[formIndex].label == "Stream" {
                    newForm[formIndex].inputText = savedEducation.stream
                }
                
                if newForm[formIndex].label == "Start year" {
                    newForm[formIndex].inputText = savedEducation.startYear
                }
                
                if newForm[formIndex].label == "End year" {
                    newForm[formIndex].inputText = savedEducation.endYear
                }
                
                if newForm[formIndex].label == "Institute/Collage name" {
                    newForm[formIndex].inputText = savedEducation.collageName
                }
            }
            
            fullEducationList.append(newForm)
        }
        
        educationDetailsFields.removeAll()
        educationDetailsFields.append(contentsOf: fullEducationList)
        
    }
    
    func clearAllFields() {
        
        selectedProfileImage = .init(named: "defaultProfileBg")
        
        personalDetailsFields = personalDetailsFields.map { person in
            var updatedPerson = person
            updatedPerson.inputText = ""
            return updatedPerson
        }
        
        addressDetailsFields = addressDetailsFields.map { section in
            section.map { person in
                var updatedPerson = person
                updatedPerson.inputText = ""
                return updatedPerson
            }
        }

        educationDetailsFields = educationDetailsFields.map { section in
            section.map { person in
                var updatedPerson = person
                updatedPerson.inputText = ""
                return updatedPerson
            }
        }
    }
}

extension PersonFormViewModel {
    
    func isEditProfile() -> Bool {
        return editPerson == nil
    }
    
    func isAllPersonFieldEmpty() -> Bool {
        
        let isPersonalDetails = personalDetailsFields.map(\.inputText).allSatisfy { $0.isEmpty }
        let isAddress = addressDetailsFields.compactMap{ $0.map(\.inputText).allSatisfy { $0.isEmpty } }.allSatisfy { $0 == true }
        let isEducation = educationDetailsFields.compactMap{ $0.map(\.inputText).allSatisfy { $0.isEmpty } }.allSatisfy { $0 == true }
        
        return isPersonalDetails || isAddress || isEducation
    }
    
}
