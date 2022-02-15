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
    
    
    // Register the user in the database
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
    
    //Create a request to get the data
    func getData(context: NSManagedObjectContext) -> [Users] {
        var data = [Users]()
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<Users>()
         
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Users", in: context)
         
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
         
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
    
    // At the time of logging in it is validated if the data is correct
    func Login(results: [Users]) -> Bool {
        var stateLogin = false
        var statePassword = false
        if self.email.isEmpty || !self.email.contains("@"){
            self.messageAlert = "No has ingresado un correo valido"
        } else {
            results.forEach { item in
                if item.email == self.email && item.password == self.password{
                    stateLogin = true
                } else if item.email == self.email && item.password != self.password {
                    statePassword = true
                    print("Contraseña invalida")
                    self.messageAlert = "Contraseña invalida"
                }
            }
    
            if stateLogin {
                print("Success")
            } else if !stateLogin && !statePassword {
                self.messageAlert = "Usuario no registrado"
                print("Usuario no registrado")
            }
        }
        return stateLogin
    }
    
    // Check if the user is registered
    func validateUser(results: [Users]) -> Bool {
        var validateUser = false
        
        results.forEach { item in
            if self.email == item.email {
                validateUser = true
            }
        }
        
        return validateUser
    }
    
    // Validate the fields of the registration form
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
    
    // Reset the fields
    func resetFields() {
        self.name = ""
        self.lastName = ""
        self.email = ""
        self.numberPhone = ""
        self.password = ""
        self.confirmPasswrod = ""
    }
        

}
