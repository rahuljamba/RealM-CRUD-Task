//
//  PersonFormView.swift
//  JarvisTask
//
//  Created by Apple on 13/02/25.
//
import SwiftUI

struct PersonFormView: View {
    
    @StateObject private var viewModel = PersonFormViewModel(DatabaseManager())
    @Binding var showFormView: Bool
    var personModel: PersonModel? = nil
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Button {
                showFormView = false
            } label: {
                Label("Fill form", systemImage: "xmark.circle.fill")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 20))
                    .padding(.leading, 15)
            }
            
            ScrollView {

                //MARK: Profile Image View
                
                PersonProfileView(showActionSheet: $viewModel.showActionSheet, selectedProfileImage: viewModel.selectedProfileImage)
                
                //MARK: Personal Details
                
                AddDetailFormView(viewModel: viewModel, fieldsArray: $viewModel.personalDetailsFields, formType: .personalDetail)
                
                //MARK: Address View
                
                AddMultipleFormView(viewModel: viewModel, fieldsArray: $viewModel.addressDetailsFields, formType: .address)
                
                //MARK: Education View
                
                AddMultipleFormView(viewModel: viewModel, fieldsArray: $viewModel.educationDetailsFields, fieldType: .dropDown, formType: .education)
                
                //MARK: Submit Button
                
                Button {
                    print("press Submit")
                    viewModel.submitInformation()
                } label: {
                    Text("Submit")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .frame(width: 160, height: 50)
                        .background(Color.royalBlue)
                        .roundCorner(8)
                }
                .padding(.top, 50)
                
            }
        }
        .onAppear(perform: {
            guard let person = personModel else { return }
            viewModel.editPerson(person)
        })
        .background(Color.alabaster)
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("Choose Media Type"),
                buttons: [
                    .default(Text("Camera")) {
                        // Handle Option 1 action
                        print("Option 1 selected")
                        viewModel.sourceType = .camera
                        viewModel.showPresentSheet = true
                    },
                    .default(Text("Gallery")) {
                        // Handle Option 2 action
                        print("Option 2 selected")
                        viewModel.sourceType = .photoLibrary
                        viewModel.showPresentSheet = true
                    },
                    .cancel(Text("Cancel").foregroundStyle(Color.red)) {
                        // Handle Cancel action
                        print("Action sheet dismissed")
                    },
                ]
            )
        }
        .sheet(isPresented: $viewModel.showPresentSheet) {
            ImagePickerView(selectedImage: $viewModel.selectedProfileImage, sourceType: viewModel.sourceType)
        }
    }
}



