//
//  LoginView.swift
//  iosadv-8
//
//  Created by Dmitrii Lobanov on 16.06.2022.
//

import SwiftUI

struct LoginView: View {
    
    enum Field: Hashable {
        case username
        case password
    }
    
    @State private var showAlert = false
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    @State private var bioAuthCheckPosibility = BioAuth.none
    @State private var authResult: Bool?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            VStack(spacing: 100) {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onAppear {
                        
                        bioAuthCheckPosibility = LocalAuthorizationService().checkBioAuthPossibility()
                        
                    }
                
                VStack(spacing: 0) {
                    
                    TextField("Email or phone (введите 123)", text: $username)
                        .padding()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = .password
                        }
                        .focused($focusedField, equals: .username)
                    
                    Divider().frame(height: 1).background(Color("TFBorderColor"))
                    
                    SecureField("Password (введите 123)", text: $password)
                        .padding()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                }
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("TFBorderColor"), style: StrokeStyle(lineWidth: 1.0)))
            }
            
            Button {
                authResult = LocalAuthorizationService().loginSuccess(login: username, password: password)
            }
        label: {
            HStack {
                Spacer()
                Text("Вход")
                Spacer()
            }
        }
        .padding()
        .contentShape(Rectangle())
        .background(Color("ButtonColor"))
        .foregroundColor(.white)
        .cornerRadius(10)
        .alert("Неверные данные авторизации", isPresented: $showAlert) {
            Button("OK", role: .cancel) { } }
            
            Button {
                
                LocalAuthorizationService().authorizeIfPossible { result in
                    authResult = result
                }
                
            } label: {
                switch bioAuthCheckPosibility {
                case BioAuth.touchID:
                    Image("touchID")
                        .resizable()
                        .frame(width: 50, height: 50)
                case BioAuth.faceID:
                    Image("faceID")
                        .resizable()
                        .frame(width: 50, height: 50)
                case BioAuth.none:
                    EmptyView()
                }
            }
            
            NavigationLink(destination: MainView(), tag: true, selection: $authResult) {}
            
            Spacer()
        }
        .padding(EdgeInsets(top: 100,
                            leading: 16,
                            bottom: 0,
                            trailing: 16))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
