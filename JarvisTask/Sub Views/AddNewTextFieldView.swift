//
//  AddNewTextFieldView.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//

import SwiftUI

struct AddNewTextFieldView: View {
    
    @ObservedObject var viewModel: PersonFormViewModel
    @Binding var personDetail: PersonDetailModel
    
    @State private var showDatePicker = false
    @State private var showPicker = false
    @State private var selectedDate = Date()
    @State private var selectedPickerValue: String = ""
    
    var fieldType: TextFieldType = .normal
    let formType: PersonFormType
    
    var body: some View {
        HStack {
            
            TextField(personDetail.placeHolderText, text: $personDetail.inputText)
                .disabled((fieldType == .delete || fieldType == .dropDown || fieldType == .calendar))
            
            if isPressTextField {
                fieldType.textFieldImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: fieldType.textFieldImageSize.width, height: fieldType.textFieldImageSize.height)
            }
        }
        .padding(.horizontal)
        .frame(height: 56)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(viewModel.isTextFieldEmpty ? .red : .mobster, lineWidth: 1)
        )
        .overlay(alignment: .leadingLastTextBaseline) {
            GeometryReader { geo in
                Text(personDetail.label)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 5)
                    .frame(height: 16)
                    .background(Color.white)
                    .offset(y: 15)
            }
        }
        .background(Color.white)
        .onTapGesture {
            if isPressTextField {
                if fieldType == .delete {
                    viewModel.deleteMore(formType, deleteItem: personDetail)
                }
                
                if isShowDatePickerView {
                    showDatePicker = true
                }
                
                if isShowPickerView {
                    showPicker = true
                }
            }
        }
        
        .popover(isPresented: $showDatePicker, content: {
            DatePickerView(selectedDate: $selectedDate, dismiss: $showDatePicker)
                .presentationDetents([.medium])
                .onChange(of: selectedDate) { _, newValue in
                    personDetail.inputText = formattedDate
                }
        })
        .popover(isPresented: $showPicker) {
            PickerView(selectedPickerValue: $selectedPickerValue, pickerArray: returnPickerArray)
                .onChange(of: selectedPickerValue) { _, newValue in
                    personDetail.inputText = newValue
                }
        }
    }
}

extension AddNewTextFieldView {
    
    var isPressTextField: Bool {
        return fieldType == .delete || fieldType == .dropDown || fieldType == .calendar
    }
    
    var isShowDatePickerView: Bool {
        return fieldType == .calendar || personDetail.label == "Start year" || personDetail.label == "End year"
    }
    
    var isShowPickerView: Bool {
        return personDetail.label == "Level" || personDetail.label == "Stream" || personDetail.label == "Institute/Collage name"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    var returnPickerArray: [String] {
        if personDetail.label == "Level" {
            return AppConstant.educationLevel
        }
        
        if personDetail.label == "Stream" {
            return AppConstant.educationStream
        }
        
        if personDetail.label == "Institute/Collage name" {
            return AppConstant.educationColleges
        }
        
        return []
    }
}
