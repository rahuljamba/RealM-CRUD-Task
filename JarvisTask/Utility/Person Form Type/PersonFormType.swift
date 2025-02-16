//
//  PersonFormType.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//


enum PersonFormType: String {
    
    case personalDetail
    case address
    case education
    
    var title: String {
        switch self {
            case .personalDetail:
                "Personal Details"
            case .address:
                "Address"
            case .education:
                "Education"
        }
    }
    
    var moreButtonTitle: String {
        switch self {
            case .personalDetail:
                "Add more mobile no."
            case .address:
                "Add more address"
            case .education:
                "Add more education"
        }
    }
}
