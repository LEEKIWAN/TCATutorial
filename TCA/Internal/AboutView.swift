//
//  SwiftUIView.swift
//  TCA
//
//  Created by 이기완 on 2023/03/29.
//

import SwiftUI

struct AboutView: View {
    let readMe: String
    var body: some View {
        DisclosureGroup("About this case study") {
            Text(readMe)
        }
    }
}

