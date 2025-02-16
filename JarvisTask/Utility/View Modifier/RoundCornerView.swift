//
//  RoundCornerView.swift
//  JarvisTask
//
//  Created by Apple on 16/02/25.
//
import SwiftUI

struct RoundCornerView: ViewModifier {
    
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
