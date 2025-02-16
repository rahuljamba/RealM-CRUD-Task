//
//  PersonModel.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//

import Foundation
import RealmSwift

class PersonModel: Object, Identifiable {
    
    @Persisted(primaryKey: true) private(set) var id: ObjectId
    @Persisted var profilePicture: String?
    
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var dob: String
    @Persisted var mobileNumbers: List<String>
    @Persisted var addressList: List<AddressModel>
    @Persisted var educationList: List<EducationModel>
}




