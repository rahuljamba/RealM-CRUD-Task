//
//  PersonCellView.swift
//  JarvisTask
//
//  Created by Apple on 16/02/25.
//
import SwiftUI

struct PersonCellView: View {
    
    @ObservedObject var viewModel: PersonListViewModel
    let person: PersonModel
    
    var body: some View {
        VStack{
            HStack {
                
                viewModel.returnPersonImage(person.profilePicture ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .roundCorner(8)
                
                VStack(alignment: .leading) {
                    Text("\(person.firstName) \(person.lastName)")
                        .font(.system(size: 14)).bold()
                    
                    Text("\(person.mobileNumbers.first!)")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Image(.editProfile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        viewModel.editPerson = person
                        viewModel.showFormView = true
                    }
            }
            .padding(.horizontal)
            
            HStack (alignment: .top) {
                
                Image("locationMarker")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 21, height: 12)
                
                
                Text(viewModel.fullAddress(person))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.black)
                
                Spacer()
            }
            .padding([.top, .horizontal])
            
            Divider()
                .frame(width: UIScreen.main.bounds.width * 0.5)
            
            HStack (alignment: .top) {
                
                Image("graduationCap")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 21, height: 12)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.fullEducation(person).stream)
                        .font(.system(size: 14)).bold()
                        .foregroundStyle(Color.black)
                    Text(viewModel.fullEducation(person).duration)
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(Color.gray)
                    Text(viewModel.fullEducation(person).location)
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(Color.black)
                }
                
                Spacer()
            }
            .padding([.top, .horizontal])
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color.alabaster)
        .roundCorner(12)
    }
}
