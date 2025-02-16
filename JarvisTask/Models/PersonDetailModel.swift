//
//  PersonDetailModel.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//
import Foundation

protocol PersonDetailModelProtocol: Identifiable {
    var fieldNNumber: Int { get }
}

struct PersonDetailModel: PersonDetailModelProtocol {
    
    var id: UUID = .init()
    var label: String
    var fieldNNumber: Int = 0
    var formNumber: Int = 0
    var placeHolderText: String
    var inputText: String
   
}
