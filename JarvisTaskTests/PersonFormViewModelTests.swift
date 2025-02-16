//
//  PersonFormViewModelTests.swift
//  JarvisTaskTests
//
//  Created by Apple on 16/02/25.
//

import XCTest
import RealmSwift
@testable import JarvisTask

class PersonFormViewModelTests: XCTestCase {
    
    var viewModel: PersonFormViewModel!
    var mockDatabaseManager: MockDatabaseManager!
    
    override func setUp() {
        super.setUp()
        mockDatabaseManager = MockDatabaseManager()
        viewModel = PersonFormViewModel(mockDatabaseManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDatabaseManager = nil
        super.tearDown()
    }
    
    // MARK: - Test Initialization
    
    func testInitialization() {
        XCTAssertNotNil(viewModel, "ViewModel should not be nil")
        XCTAssertEqual(viewModel.personalDetailsFields.count, 3, "Personal details fields should be initialized")
        XCTAssertEqual(viewModel.addressDetailsFields.count, 1, "Address details fields should be initialized")
        XCTAssertEqual(viewModel.educationDetailsFields.count, 1, "Education details fields should be initialized")
        XCTAssertEqual(viewModel.mobileFields, 1, "Mobile fields should be initialized to 1")
    }
    
    // MARK: - Test Adding Fields
    
    func testAddMoreMobileField() {
        viewModel.addMore(.personalDetail)
        XCTAssertEqual(viewModel.mobileFields, 2, "Mobile fields count should increase by 1")
        XCTAssertEqual(viewModel.personalDetailsFields.count, 4, "Personal details fields should increase by 1")
    }
    
    func testAddMoreAddressForm() {
        viewModel.addMore(.address)
        XCTAssertEqual(viewModel.addressDetailsFields.count, 2, "Address details fields should increase by 1")
    }
    
    func testAddMoreEducationForm() {
        viewModel.addMore(.education)
        XCTAssertEqual(viewModel.educationDetailsFields.count, 2, "Education details fields should increase by 1")
    }
    
    // MARK: - Test Deleting Fields
    
    func testDeleteMobileField() {
        viewModel.addMore(.personalDetail)
        let mobileFieldToDelete = viewModel.personalDetailsFields.last!
        viewModel.deleteMore(.personalDetail, deleteItem: mobileFieldToDelete)
        XCTAssertEqual(viewModel.mobileFields, 1, "Mobile fields count should decrease by 1")
        XCTAssertEqual(viewModel.personalDetailsFields.count, 3, "Personal details fields should decrease by 1")
    }
    
    func testDeleteMoreAddressForm() {
        viewModel.addMore(.address)
        viewModel.deleteMore(.address, deleteIndex: 0)
        XCTAssertEqual(viewModel.addressDetailsFields.count, 1, "Address details fields should decrease by 1")
    }
    
    func testDeleteMoreEducationForm() {
        viewModel.addMore(.education)
        viewModel.deleteMore(.education, deleteIndex: 0)
        XCTAssertEqual(viewModel.educationDetailsFields.count, 1, "Education details fields should decrease by 1")
    }
    
    // MARK: - Test Saving Person Information
    
    func testSavePersonInformation() {
        // Set up mock data
        viewModel.personalDetailsFields[0].inputText = "John"
        viewModel.personalDetailsFields[1].inputText = "Doe"
        viewModel.personalDetailsFields[2].inputText = "01/01/1990"
        viewModel.addressDetailsFields[0][0].inputText = "123"
        viewModel.addressDetailsFields[0][1].inputText = "Main St"
        viewModel.addressDetailsFields[0][2].inputText = "12345"
        viewModel.addressDetailsFields[0][3].inputText = "City"
        viewModel.addressDetailsFields[0][4].inputText = "State"
        viewModel.educationDetailsFields[0][0].inputText = "Bachelor"
        viewModel.educationDetailsFields[0][1].inputText = "Computer Science"
        viewModel.educationDetailsFields[0][2].inputText = "2010"
        viewModel.educationDetailsFields[0][3].inputText = "2014"
        viewModel.educationDetailsFields[0][4].inputText = "XYZ University"
        
        // Save person information
        viewModel.savePersonInformation()
        
        // Verify that the database manager was called
        XCTAssertTrue(mockDatabaseManager.saveCalled, "Database manager's save method should be called")
        XCTAssertFalse(viewModel.isTextFieldEmpty, "Text fields should not be empty")
    }
    
    func testSavePersonInformationWithEmptyFields() {
        // Ensure all fields are empty
        viewModel.clearAllFields()
        
        // Save person information
        viewModel.savePersonInformation()
        
        // Verify that the database manager was not called
        XCTAssertFalse(mockDatabaseManager.saveCalled, "Database manager's save method should not be called")
        XCTAssertTrue(viewModel.isTextFieldEmpty, "Text fields should be empty")
    }
    
    // MARK: - Test Clearing All Fields
    
    func testClearAllFields() {
        // Set up mock data
        viewModel.personalDetailsFields[0].inputText = "John"
        viewModel.addressDetailsFields[0][0].inputText = "123"
        viewModel.educationDetailsFields[0][0].inputText = "Bachelor"
        
        // Clear all fields
        viewModel.clearAllFields()
        
        // Verify that all fields are cleared
        XCTAssertTrue(viewModel.personalDetailsFields.allSatisfy { $0.inputText.isEmpty }, "All personal details fields should be cleared")
        XCTAssertTrue(viewModel.addressDetailsFields.allSatisfy { $0.allSatisfy { $0.inputText.isEmpty } }, "All address details fields should be cleared")
        XCTAssertTrue(viewModel.educationDetailsFields.allSatisfy { $0.allSatisfy { $0.inputText.isEmpty } }, "All education details fields should be cleared")
    }
    
    // MARK: - Test Field Validation
    
    func testIsAllPersonFieldEmpty() {
        // Ensure all fields are empty
        viewModel.clearAllFields()
        XCTAssertTrue(viewModel.isAllPersonFieldEmpty(), "All fields should be empty")
        
        // Fill one field
        viewModel.personalDetailsFields[0].inputText = "John"
        XCTAssertFalse(viewModel.isAllPersonFieldEmpty(), "Fields should not be empty")
    }
}

// MARK: - MockDatabaseManager

class MockDatabaseManager: DatabaseManager {
    var saveCalled = false
   
    func save(_ model: PersonModel, completion: (Bool) -> Void) {
        saveCalled = true
        completion(true)
    }
    
    override func saveImageToFileSystem(image: UIImage, name: String) -> String? {
        return "mock_image_path"
    }
}
