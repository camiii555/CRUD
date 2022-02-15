//
//  Home.swift
//  CRUD
//
//  Created by MacBook J&J  on 12/02/22.
//

import SwiftUI

struct Home: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var model : ViewModel
    var body: some View {
        
        ZStack{
            Text("Hello")
            
        }.navigationTitle("Home")
            .onAppear {
                model.resetFields()
            }
            .onDisappear {
                self.presentation.wrappedValue.dismiss()
            }
    }
}

