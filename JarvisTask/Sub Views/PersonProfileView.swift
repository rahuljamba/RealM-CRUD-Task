//
//  PersonProfileView.swift
//  JarvisTask
//
//  Created by Apple on 14/02/25.
//
import SwiftUI

struct PersonProfileView: View {
    
    @Binding var showActionSheet: Bool
    var selectedProfileImage: UIImage?
    
    var body: some View {
        
        Button {
            
            showActionSheet = true
            
        } label: {
            
            VStack(alignment: .center) {
                
                Image(uiImage: selectedProfileImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 125, height: 125, alignment: .center)
                    .roundCorner(27)
                    .overlay(alignment: .center, content: {
                        if !showActionSheet {
                            Image("defaultProfileImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 74, height: 74)
                        }
                    })
                
                HStack(alignment: .center) {
                    Image("cameraAlt")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                    
                    Text("Upload photo")
                        .font(.system(size: 14))
                    
                }
            }
            .frame(maxWidth: .infinity)
            .background(.alabaster)
            .listRowSeparator(.hidden)
            .padding(.top, 60)
        }
    }
}
