//
//  PersonListView.swift
//  JarvisTask
//
//  Created by Apple on 13/02/25.
//

import SwiftUI

struct PersonListView: View {
    
    @StateObject private var viewModel = PersonListViewModel(databaseManager: DatabaseManager())
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Image("profileImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                HStack {
                    Image(systemName:"magnifyingglass")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 12)
                    
                    TextField("Search person...", text: $viewModel.searchPersonText)
                        .onChange(of: viewModel.searchPersonText, { oldValue, newValue in
                            print("newValue = \(newValue)")
                        })
                }
                .frame(height: 40)
                .background(Color.alabaster)
                .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .padding(.horizontal)
            
            if viewModel.personList.isEmpty {
                
                ContentUnavailableView(
                    "No Persons Available",
                    systemImage: "person.3",
                    description:
                        Text("Try adding a new person click on bottom right corner button.")
                )
                
            }else {
                List {
                    ForEach(viewModel.filteredPersons, id: \.id) { person in
                        PersonCellView(viewModel: viewModel, person: person)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(.white)
        .onAppear(perform: {
            viewModel.getPersonsList()
        })
        .fullScreenCover(isPresented: $viewModel.showFormView, content: {
            PersonFormView(showFormView: $viewModel.showFormView, personModel: viewModel.editPerson)
        })
        .onChange(of: viewModel.showFormView, { _, newValue in
            if !newValue {
                viewModel.getPersonsList()
            }
        })
        .overlay {
            ZStack {
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .frame(width: 70, height: 70)
            .background(Color.royalBlue)
            .clipShape(Circle())
            .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 150)
            .onTapGesture {
                viewModel.editPerson = nil
                viewModel.showFormView = true
            }
        }
    }
}

