//
//  Login.swift
//  CRUD
//
//  Created by MacBook J&J  on 28/01/22.
//

import SwiftUI

struct Login: View {
    @StateObject var model = ViewModel()
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Users.entity(), sortDescriptors: [NSSortDescriptor(key: "email", ascending: true)], animation: .spring()) var results: FetchedResults<Users>
     
    let sizeCreen = UIScreen.main.bounds.width
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: Home(model: model), tag: "Home", selection: $model.showHome){
                }
                Image("usuario")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding(.all)
                HStack{
                    Image(systemName: "envelope")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 35)
                    TextField("Email",text: $model.email)
                }
                .padding()
                .background(Color.blue.opacity(0.12))
                .cornerRadius(15)
                .padding(.horizontal)
                         
                HStack{
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 35)
                    SecureField("Password",text: $model.password)
                             
                }
                    .padding()
                    .background(Color.blue.opacity(0.12))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                Button {
                    model.getData(context: context)
                    if model.Login(results: results) == true {
                        model.showHome = "Home"
                    } else {
                        model.showAlert.toggle()
                    }
                } label: {
                    Text("Iniciar Session")
                }.padding()
                    .frame(width: (CGFloat(sizeCreen) - 150), height: 40)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .alert(model.messageAlert, isPresented: $model.showAlert){}
                
                Button {
                        
                } label: {
                    Text("olvidó su contraseña?")
                        .foregroundColor(.blue)
                }.frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                
                Spacer(minLength: 0)
                Spacer(minLength: 0)
                Spacer(minLength: 0)
                        
                Button {
                    model.show.toggle()
                    model.resetFields()
                } label: {
                    Text("Registrarse")
                }.sheet(isPresented: $model.show) {
                    Register(model: model)
                }.padding(.bottom, 20)
                
            }.navigationTitle("Login")
        }
    }
}
