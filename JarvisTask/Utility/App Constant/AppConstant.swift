//
//  AppConstant.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//

struct AppConstant {
    
    static let educationLevel = ["Primary Education", "Upper Primary", "Secondary Education", "Higher Secondary Education", "Higher Education"]
    
    static let educationStream = ["Science", "Commerce", "Arts", "Vocational", "Tech Specializations"]
    
    static let educationColleges = ["(IIT) Bombay ", "(IISc), Bangalore", "(IIT) Delhi ", "(AIIMS), Delhi", "(IIM) Ahmedabad"]
    
    static func personalDetail() -> [PersonDetailModel] {
        
        let personalDetail: [PersonDetailModel] = [.init(label: "First name", placeHolderText: "Enter you first name", inputText: ""), .init(label: "Last name", placeHolderText: "Enter your last name", inputText: ""), .init(label: "DOB", placeHolderText: "Select date of birth", inputText: ""), .init(label: "Mobile No.", fieldNNumber: 1, placeHolderText: "Enter your mobile No.", inputText: "")]
        
        return personalDetail
    }
    
    static func addressForm() -> [PersonDetailModel] {
        
        let addressArray: [PersonDetailModel] = [.init(label: "House no, flat, building, apartment", placeHolderText: "Enter your address", inputText: ""), .init(label: "Area, street, sector, village", placeHolderText: "Enter your address", inputText: ""), .init(label: "Pin code", placeHolderText: "Enter your pin code", inputText: ""), .init(label: "Town/City", placeHolderText: "Enter your town", inputText: ""), .init(label: "State", placeHolderText: "Enter your state", inputText: "")]
   
        return addressArray
    }
    
    static func educationForm() -> [PersonDetailModel] {
        
        let educationArray: [PersonDetailModel] = [.init(label: "Level", placeHolderText: "Select level", inputText: ""), .init(label: "Stream", placeHolderText: "Select stream", inputText: ""), .init(label: "Start year", placeHolderText: "Select start year", inputText: ""), .init(label: "End year", placeHolderText: "Select end year", inputText: ""), .init(label: "Institute/Collage name", placeHolderText: "Enter collage name", inputText: "")]
        
        return educationArray
    }
}
