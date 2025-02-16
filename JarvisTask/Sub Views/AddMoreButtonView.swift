//
//  AddMoreButtonView.swift
//  JarvisTask
//
//  Created by Apple on 15/02/25.
//
import SwiftUI

struct AddMoreButtonView: View {
    
    @ObservedObject var viewModel: PersonFormViewModel
    let formType: PersonFormType
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button {
                
                print("press add more button")
                
                withAnimation {
                    viewModel.addMore(formType)
                }
                
            } label: {
                Label(formType.moreButtonTitle, image: .addCircle)
                    .imageScale(.small)
                    .foregroundStyle(Color.royalBlue)
                    .font(.system(size: 14))
                    .frame(height: 36)
                    .padding([.horizontal], 10)
                    .background(Color.aliceBlue)
                    .roundCorner(8)
            }
        }
        .padding(.horizontal, formType == .personalDetail ? 0 : 20)
        .padding(.bottom, 10)
    }
}
