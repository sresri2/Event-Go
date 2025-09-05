//
//  SignUpView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/4/23.
//

//
//  LoginView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/1/23.
//

import SwiftUI
import Foundation
import Security

struct SignUpView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var warning = ""
    @State var isAuthenticated: Bool = false
    
    var body: some View {
        let serviceName = "com.sresri.Event-Go"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        
        NavigationView {
            VStack {
                Spacer()
                Text("EventGo")
                    .font(.cursiveFont(size: 50))
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .textContentType(.username)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .textContentType(.newPassword)
                
                SecureField("Confirm Password", text: $confirmpassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .textContentType(.newPassword)
                Text(warning).foregroundColor(.red)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20.0).frame(maxWidth: .infinity,maxHeight:50).padding().foregroundColor(buttonColor)
                    Button(action: {
                        if password != "" && username != "" && password == confirmpassword && isUsernameUnique(username) {
                            warning = ""
                            let password2 = password.data(using: .utf8)!
                            let status = SecItemAdd(query as CFDictionary, nil)
                            
                            if status == errSecSuccess {
                                print("Password saved successfully!")
                                isAuthenticated = true
                                UserDefaults.standard.set(username, forKey: "UserName")
                            } else {
                                print("Error saving password: \(status)")
                            }
                        } else if password != confirmpassword {
                            warning = "Passwords do not match"
                        } else if !isUsernameUnique(username) {
                            warning = "Username already in use."
                        } else if password == "" || username == "" {
                            warning = "Please fill out all fields"
                        }

                        
                    }, label: {
                        Text("Create Account")
                    })
                        
                    .frame(maxWidth: .infinity,maxHeight:50)
                }
                
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isAuthenticated) {
                    EmptyView()
                 }
                 
                
                Spacer()
            }
            .padding()
            .background(back)
            .ignoresSafeArea()
        }
        
    }
    func isUsernameUnique(_ username: String) -> Bool {
            guard let query = buildKeychainQuery(for: username) else { return true }
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            return status != errSecSuccess
        }
        
        func buildKeychainQuery(for username: String) -> [String: Any]? {
            let serviceName = "com.sresri.Event-Go"
            return [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: username,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: false
            ]
        }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

