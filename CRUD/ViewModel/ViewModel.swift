//
//  ViewModel.swift
//  CRUD
//
//  Created by MacBook J&J  on 28/01/22.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class ViewModel: ObservableObject {
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var numberPhone = ""
    @Published var dateOfBirth = Date()
    @Published var show = false
    @Published var confirmPasswrod = ""
    @Published var showAlert = false
    @Published var messageAlert = ""
    @Published var showHome: String? = nil
    
    func register(context: NSManagedObjectContext) {
        let newRegister = Users(context: context)
        newRegister.name = self.name
        newRegister.last_name = self.lastName
        newRegister.date_of_birth = self.dateOfBirth
        newRegister.email = self.email
        newRegister.password = self.password
        
        do {
            try context.save()
            print("Guardado exitoso")
            show.toggle()
        } catch let error as NSError {
            print("No se ha podido realizar el registro", error.localizedDescription)
        }
    }
    
    func Login(results: FetchedResults<Users>) -> Bool {
        var stateLogin = false
        
        if self.email.isEmpty || !self.email.contains("@"){
            self.messageAlert = "No has ingresado un correo valido"
        } else {
            results.forEach { items in
                if items.email == self.email && items.password == self.password{
                    stateLogin = true
                } else if items.email == self.email && items.password != self.password {
                    print("Contrasena invalida")
                    self.messageAlert = "Contresena invalida"
                }
            }
            
            if stateLogin {
                print("Success")
            } else {
                self.messageAlert = "Usuario no registrado"
                print("Usuario no registrado")
            }
        }
        return stateLogin
    }
    
    func getData(context: NSManagedObjectContext) -> [NSFetchRequestResult] {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
         
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Users", in: context)
         
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
         
        var data = [NSFetchRequestResult]()
        do {
            let result = try context.fetch(fetchRequest)
            data = result
            print(data)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return data
    }

    func validateUser(results: FetchedResults<Users>) -> Bool {
        var validate = false
        results.forEach { item in
            if item.email == self.email {
                validate = true
            }
        }
        return validate
    }
    
    func validateFields() -> String {
        var message = ""
        if self.name == "" || self.lastName == "" || self.email == "" || self.numberPhone == "" || self.password == "" || self.confirmPasswrod == "" {
            message = "Debe completar todos los campos "
        }
        
        if self.password != self.confirmPasswrod {
            message = "Las contraseñas deben ser iguales"
        }
        
        if !self.email.contains("@") && self.email != "" {
            message = "Correo invalido"
        }
        
        return message
    }
    
    func resetFields() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.numberPhone = ""
        self.password = ""
        self.confirmPasswrod = ""
    }
        

}
