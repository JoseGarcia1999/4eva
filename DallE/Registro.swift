//
//  Registro.swift
//  DallE
//
//  Created by MacOsX on 5/17/24.
//

import SwiftUI
import FirebaseAuth

struct Registro: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isRegistered: Bool = false

    var body: some View {
        VStack {
            Text("Registro de Usuario")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Confirmar Contraseña", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: registerUser) {
                Text("Registrar")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if isRegistered {
                Text("Usuario registrado exitosamente")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }

    func registerUser() {
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.errorMessage = nil
                self.isRegistered = true
            }
        }
    }
}

struct Registro_Previews: PreviewProvider {
    static var previews: some View {
        Registro()
    }
}

