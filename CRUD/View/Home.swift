//
//  Home.swift
//  CRUD
//
//  Created by MacBook J&J  on 12/02/22.
//

import SwiftUI

struct Home: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var model: ViewModel
    @FetchRequest(entity: Users.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], animation: .spring()) var results: FetchedResults<Users>
    
    var body: some View {
        NavigationView{
            List{
                ForEach(results){ item in
                    VStack {
                        HStack() {
                            Text("Nombre:").frame(alignment: .leading)
                            Text(item.number_phone ?? "")
                            //Text("\(item.name ?? "") \(item.last_name ?? "")")
                        }
                    }.contextMenu{
                        Button {
                            model.sendData(item: item)
                            model.show.toggle()
                        } label: {
                            Text("Editar")
                            Image(systemName: "pencil")
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Borrar Registro")
                            Image(systemName: "trash")
                        }
                    }
                }
            }.navigationTitle("Usuarios Registrados")
                .toolbar {
                    NavigationLink {
                        AddNewUser(model: model)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $model.show) {
                    Register(model: model)
                }

        }.onAppear{
            model.resetFields()
        }
        .onDisappear {
            presentation.wrappedValue.dismiss()
        }
    }
}

/*    .onDisappear {
        self.presentation.wrappedValue.dismiss()
    } */

