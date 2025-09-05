//
//  LoginView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/1/23.
//

import SwiftUI
import Foundation
import Security

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State var isAuthenticated: Bool = false
    @State var signingUp: Bool = false
    @State var forgotPassword: Bool = false
    @State var deletingAccount: Bool = false
    
    var body: some View {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.sresri.Event-Go",
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
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
                    .textContentType(.username)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textContentType(.password)
                
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0).frame(maxWidth: .infinity,maxHeight:50).padding().foregroundColor(buttonColor)
                        Button(action: {
                            var result: AnyObject?
                            let status = SecItemCopyMatching(query as CFDictionary, &result)
                            
                            if status == errSecSuccess, let passwordData = result as? Data {
                                let retrievedPassword = String(data: passwordData, encoding: .utf8)
                                print("Password retrieved successfully")
                                if password == retrievedPassword {
                                    isAuthenticated = true
                                    UserDefaults.standard.set(username, forKey: "UserName")
                                }
                            } else {
                                print("Error retrieving password: \(status)")
                            }
                            
                            
                        }, label: {
                            Text("Log In")
                        })
                            
                        .frame(maxWidth: .infinity,maxHeight:50)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).frame(maxWidth:300,maxHeight:30).padding().foregroundColor(buttonColor)
                        Button(action: {
                            signingUp = true
                        }, label: {
                            Text("Create New Account")
                        })
                            
                        .frame(maxWidth: .infinity,maxHeight:50)
                    }
                    Spacer().frame(height: 0.1)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).frame(maxWidth:300,maxHeight:30).padding().foregroundColor(buttonColor)
                        Button(action: {
                            forgotPassword = true
                        }, label: {
                            Text("Forgot Password")
                        })
                            
                        .frame(maxWidth: .infinity,maxHeight:50)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).frame(maxWidth:300,maxHeight:30).padding().foregroundColor(buttonColor)
                        Button(action: {
                            deletingAccount = true
                        }, label: {
                            Text("Delete Account")
                        })
                            
                        .frame(maxWidth: .infinity,maxHeight:50)
                    }
                    
                }
                
                NavigationLink(destination: PasswordResetView().navigationBarBackButtonHidden(false), isActive: $forgotPassword) {
                    EmptyView()
                 }
                
                NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true), isActive: $signingUp) {
                    EmptyView()
                 }
                
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isAuthenticated) {
                    EmptyView()
                 }
                NavigationLink(destination: DeleteAccountView().navigationBarBackButtonHidden(true), isActive: $deletingAccount) {
                    EmptyView()
                 }
                 
                
                Spacer()
            }
            .padding()
            .background(back)
        .ignoresSafeArea()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
