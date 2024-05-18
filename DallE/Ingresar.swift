//
//  Ingresar.swift
//  DallE
//
//  Created by MacOsX on 5/17/24.
//

import SwiftUI
import FirebaseAuth

struct Ingresar: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Iniciar Sesión")
                    .font(.largeTitle)
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                Button(action: loginUser) {
                    Text("Ingresar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                NavigationLink(destination: OpenAI(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = "Usuario o contraseña no válidos. Por favor, inténtelo de nuevo o cree una cuenta."
                self.isLoggedIn = false
                print("Error de autenticación: \(error.localizedDescription)")
            } else {
                self.errorMessage = nil
                self.isLoggedIn = true
                print("Usuario autenticado: \(String(describing: result?.user.email))")
            }
        }
    }
}

struct Ingresar_Previews: PreviewProvider {
    static var previews: some View {
        Ingresar()
    }
}





