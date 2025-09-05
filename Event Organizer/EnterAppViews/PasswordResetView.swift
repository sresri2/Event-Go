//
//  PasswordResetView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 1/8/24.
//

import SwiftUI
import LocalAuthentication
import Security

struct PasswordResetView: View {
    @State private var isBiometricVerified = false
    @State private var newPassword = ""
    @State private var username = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        ZStack {
            back.ignoresSafeArea()
            VStack {
                if isBiometricVerified {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    SecureField("New Password", text: $newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        resetPassword()
                    }) {
                        Text("Reset Password")
                    }
                    .padding()
                    .background(buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                } else {
                    Button(action: {
                        tryBiometricAuthentication()
                    }) {
                        Text("Verify Biometrics")
                    }
                    .padding()
                    .background(buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func resetPassword() {
        guard !username.isEmpty else {
            alertMessage = "Please enter a username"
            showAlert = true
            return
        }
        
        guard !newPassword.isEmpty else {
            alertMessage = "Please enter a new password"
            showAlert = true
            return
        }

        if !usernameExists(username: username) {
            alertMessage = "Username not found"
            showAlert = true
            return
        }

        do {
            try updateGenericPasswordFor()
            alertMessage = "Password reset successfully for \(username)"
            showAlert = true
            self.presentationMode.wrappedValue.dismiss() 
        } catch {
            alertMessage = "Error resetting password"
            showAlert = true
        }
    }

    func usernameExists(username: String) -> Bool {
        guard let query = buildKeychainQuery(for: username) else { return true }
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status != errSecSuccess
    }

    func updateGenericPasswordFor() throws {
      guard let passwordData = newPassword.data(using: .utf8) else {
        print("Error converting value to data.")
        return
      }
      // 1
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: username,
        kSecAttrService as String: "com.sresri.Event-Go"
      ]

      // 2
      let attributes: [String: Any] = [
        kSecValueData as String: passwordData
      ]

      // 3
      let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else {
          alertMessage = "Username not found"
          showAlert = true
          return
      }
      guard status == errSecSuccess else {
          alertMessage = "Error Updating Password"
          showAlert = true
          return
      }
    }

    func buildKeychainQuery(for username: String) -> [String: Any]? {
        let serviceName = "com.sresri.Event-Go"
        return [
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: username,
        ]
    }

    
    func tryBiometricAuthentication() {
      // 1
      let context = LAContext()
      var error: NSError?

      // 2
      if context.canEvaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        error: &error) {
        // 3
        let reason = "Authenticate to reset your password"
        context.evaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics,
          localizedReason: reason) { authenticated, error in
          // 4
          DispatchQueue.main.async {
            if authenticated {
              // 5
              isBiometricVerified = true
            } else {
              // 6
              if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
              }
            }
          }
        }
      } else {
        // 7
        if let errorString = error?.localizedDescription {
          print("Error in biometric policy evaluation: \(errorString)")
        }
      }
    }

}

#Preview {
    PasswordResetView()
}
