//
//  DeleteAccountView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 1/8/24.
//

import SwiftUI
import LocalAuthentication
import Security

struct DeleteAccountView: View {
    @State private var isBiometricVerified = false
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
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
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        deleteAccount()
                    }) {
                        Text("Delete Account")
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
                Alert(title: Text("Account Deletion"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func deleteAccount() {
        guard !username.isEmpty else {
            alertMessage = "Please enter a username"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Please enter your password"
            showAlert = true
            return
        }
        
        guard !confirmPassword.isEmpty else {
            alertMessage = "Please confirm your password"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Password and confirm password do not match"
            showAlert = true
            return
        }
        
        if !usernameExists(username: username) {
            alertMessage = "Username not found"
            showAlert = true
            return
        }
        
        do {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: "com.sresri.Event-Go",
                kSecAttrAccount as String: username,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: true
            ]
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            if status == errSecSuccess, let passwordData = result as? Data {
                let retrievedPassword = String(data: passwordData, encoding: .utf8)
                print("Password retrieved successfully")
                if password == retrievedPassword {
                    try deleteAccountFromKeychain()
                    deleteLocalUserData()
                    alertMessage = "Account deleted successfully for \(username)"
                    showAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    alertMessage = "Password incorrect"
                    showAlert = true
                    return
                }
            } else {
                alertMessage = "Error verifying password"
                showAlert = true
                return
            }
            
            
        } catch {
            alertMessage = "Error deleting account"
            showAlert = true
        }
    }

    func deleteAccountFromKeychain() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: "com.sresri.Event-Go"
        ]
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            alertMessage = "Error deleting account from Keychain"
            showAlert = true
            return
        }
    }
    
    func deleteLocalUserData() {
        guard let username = UserDefaults.standard.string(forKey: "UserName") else {
            fatalError("Username not found in UserDefaults.")
        }

        let fileManager = FileManager.default
        let fileURL = fileURL(forUsername: username)

        do {
            // Check if the file exists before attempting to delete
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting local user data file: \(error)")
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
    func usernameExists(username: String) -> Bool {
        guard let query = buildKeychainQuery(for: username) else { return true }
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status != errSecSuccess
    }

}
