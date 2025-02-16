//
//  DatePickerView.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//
import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var dismiss: Bool
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding()

            Button("Done") {
                dismiss.toggle()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
