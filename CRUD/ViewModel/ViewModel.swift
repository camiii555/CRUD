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
    @Published var updateData = false
    @Published var updateItems: Users?
    
    // Register the user in the database
    func register(context: NSManagedObjectContext) {
        let newRegister = Users(context: context)
        newRegister.name = self.name
        newRegister.last_name = self.lastName
        newRegister.date_of_birth = self.dateOfBirth
        newRegister.number_phone = self.numberPhone
        newRegister.email = self.email.lowercased()
        newRegister.password = self.password
        
        do {
            try context.save()
            print("Guardado exitoso")
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
                if item.email == self.email.lowercased() && item.password == self.password {
                    stateLogin = true
                } else if item.email == self.email.lowercased() && item.password != self.password {
                    statePassword = true
                    print("Contrase??a invalida")
                    self.messageAlert = "Contrase??a invalida"
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
            message = "Las contrase??as deben ser iguales"
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
    
    // send data for edit
    func sendData(item: Users) {
        self.name = item.name ?? ""
        self.lastName = item.last_name ?? ""
        self.dateOfBirth = item.date_of_birth ?? Date()
        self.numberPhone = item.number_phone ?? ""
        self.email = item.email ?? ""
        self.password = item.password ?? ""
        self.confirmPasswrod = item.password ?? ""
    }
    // edit users
    func editData(context: NSManagedObjectContext) {
        self.updateItems?.name = self.name
        self.updateItems?.last_name = self.lastName
        self.updateItems?.date_of_birth = self.dateOfBirth
        self.updateItems?.number_phone = self.numberPhone
        self.updateItems?.email = self.email.lowercased()
        
        if self.password == self.confirmPasswrod {
            self.updateItems?.password = self.password
        }
        do {
            try context.save()
            show.toggle()
            updateData.toggle()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // delete users
    
    func deleteData(item: Users, context: NSManagedObjectContext) {
        context.delete(item)
        do {
            try context.save()
        } catch let error as NSError {
            print("No se ha podido borrar el usuario", error.localizedDescription)
        }
    }

}
