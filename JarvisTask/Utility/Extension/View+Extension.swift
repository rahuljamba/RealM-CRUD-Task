//
//  View+Extension.swift
//  JarvisTask
//
//  Created by Apple on 16/02/25.
//

import SwiftUI

extension View {
    func roundCorner(_ radius: CGFloat = 10) -> some View {
        self.modifier(RoundCornerView(cornerRadius: radius))
    }
}
