//
//  PickerView.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//
import SwiftUI

struct PickerView: View {
    
    @Binding var selectedPickerValue: String
    let pickerArray: [String]
    
    var body: some View {
        VStack {
            Picker("Select education", selection: $selectedPickerValue) {
                ForEach(pickerArray, id: \.self) { item in
                    Text(item)
                        .tag(item)
                }
            }
            .pickerStyle(.wheel)
            .presentationDetents([.height(200)])
        }
    }
}
