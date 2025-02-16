//
//  AddMultipleFormView.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//
import SwiftUI

struct AddMultipleFormView: View {
    
    @ObservedObject var viewModel: PersonFormViewModel
    @Binding var fieldsArray: [[PersonDetailModel]]
    
    var fieldType: TextFieldType = .normal
    let formType: PersonFormType
    
    var body: some View {
        
        VStack {
            
            ForEach(0..<fieldsArray.count, id: \.self) { index in
                AddDetailFormView(viewModel: viewModel, fieldsArray: $fieldsArray[index], fieldIndex: index, fieldType: fieldType, formType: formType)
                
            }
            
            AddMoreButtonView(viewModel: viewModel, formType: formType)
            
        }
        .background(Color.white)
        .padding(.bottom, 10)
        
    }
}
