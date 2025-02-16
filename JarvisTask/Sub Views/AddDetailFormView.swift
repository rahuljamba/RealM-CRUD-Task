//
//  AddMoreFieldView.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//
import SwiftUI

enum TextFieldType {
    case normal
    case dropDown
    case calendar
    case delete
    
    var textFieldImage: Image {
        switch self {
            case .normal:
                Image("")
            case .dropDown:
                Image(.dropDownIcon)
            case .calendar:
                Image(.calendar)
            case .delete:
                Image(.delete)
        }
    }
    
    var textFieldImageSize: CGSize {
        switch self {
            case .normal:
               .init(width: 0, height: 0)
            case .dropDown:
               .init(width: 10, height: 5)
            case .calendar:
               .init(width: 19, height: 21)
            case .delete:
               .init(width: 14, height: 18)
        }
    }
    
}

struct AddDetailFormView: View {
    
    @ObservedObject var viewModel: PersonFormViewModel
    @Binding var fieldsArray:[PersonDetailModel]
    
    var fieldIndex: Int = 0
    var fieldType: TextFieldType = .normal
    
    let formType: PersonFormType

    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Text(formType.title)
                    .font(.system(size: 15)).bold()
                    .padding(.top, 20)
                
                Spacer()
                
                if fieldIndex != 0 {
                    Button {
                        
                        withAnimation {
                            viewModel.deleteMore(formType, deleteIndex: fieldIndex)
                        }
                        
                    } label: {
                        Image(.delete)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 14, height: 18)
                    }
                }
            }
            
            LazyVStack(spacing: 30) {
                ForEach($fieldsArray, id: \.id) { field in
                    
                    if field.label.wrappedValue == "DOB" {
                        AddNewTextFieldView(viewModel: viewModel, personDetail: field, fieldType: .calendar, formType: formType)
                    }else {
                        AddNewTextFieldView(viewModel: viewModel, personDetail: field, fieldType: fieldType, formType: formType)
                    }
                }
            }
            .padding(.top)
            
            if formType == .personalDetail {
                AddMoreButtonView(viewModel: viewModel, formType: formType)
            }
            
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

