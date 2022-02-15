//
//  Register.swift
//  CRUD
//
//  Created by MacBook J&J  on 28/01/22.
//

import SwiftUI

struct Register: View {
    @ObservedObject var model: ViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Users.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var results: FetchedResults<Users>
    
    let sizeCreen = UIScreen.main.bounds.width
    var body: some View {
        ZStack {
            VStack{
                Text("Registrarse")
                    .font(.largeTitle)
                    .bold()
                TextField("Name", text: $model.name)
                    .frame(width: (CGFloat(self.sizeCreen) - 50), height: 50, alignment: .center)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                TextField("Last Name", text: $model.lastName)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                DatePicker("Date Of Birth", selection: $model.dateOfBirth)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                TextField("Number Phone", text: $model.numberPhone)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .font(.title3)
                TextField("Email", text: $model.email)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                SecureField("Password", text: $model.password)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                SecureField("Confirm Password", text: $model.confirmPasswrod)
                    .frame(width: (CGFloat(sizeCreen) - 50), height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                Button {
                    let data = model.getData(context: context)
                    let validateUser = model.validateUser(results: data)
                    model.messageAlert = model.validateFields()
                    if model.messageAlert != "" {
                        model.showAlert.toggle()
                    } else if validateUser == true {
                        model.messageAlert = "El correo ingresado ya esta registrado"
                        model.showAlert.toggle()
                    } else {
                        model.register(context: context)
                        model.resetFields()
                    }
                    
                } label: {
                    Text("Guardar")
                    Image(systemName: "square.and.arrow.down.fill")
                }.padding()
                    .frame(width: 200, height: 40, alignment: .center)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                    .alert(model.messageAlert, isPresented: $model.showAlert) {
                        Button("OK", role: .cancel){}
                    }
            }
        }
    }
}
