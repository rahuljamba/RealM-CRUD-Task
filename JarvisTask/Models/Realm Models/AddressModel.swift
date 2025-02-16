//
//  AddressModel.swift
//  JarvisTask
//
//  Created by Apple on 16/02/25.
//
import RealmSwift

class AddressModel: Object {
    @Persisted var houseNo: String
    @Persisted var area: String
    @Persisted var pinCode: String
    @Persisted var city: String
    @Persisted var state: String
}
