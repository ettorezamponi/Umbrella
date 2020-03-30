//
//  LoginView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 29/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import FBSDKLoginKit
import Firebase

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signIn() {
        session.signIn(email: email, password: password) {(result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("Welcome back!")
                .font(.system(size: 40, weight: .heavy))
            
            Text("Sign in to continue")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(Color.gray)
            
            VStack(spacing: 20) {
                TextField("Email address", text: $email)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
            }.padding(.vertical, 65)
            
            Button(action: signIn) {
                Text("Sign In")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.black)
                    .cornerRadius(20)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
                
            }
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("I'm a new user")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.primary)
                    
                    Text("Create an account")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.blue)
                    
                }
            }
            
        }.padding(.horizontal, 32)
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signUp() {
        session.signUp(email: email, password: password) {(result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("Create an account")
                .font(.system(size: 40, weight: .heavy))
            
            Text("Sign up to get started")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(Color.gray)
            
            VStack(spacing: 20) {
                TextField("Email address", text: $email)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
            }.padding(.vertical, 65)
            
            Button(action: signUp) {
                Text("Create Account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.black)
                    .cornerRadius(20)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
                
            }
            Spacer()
        }.padding(.horizontal, 32)
    }
}

struct ChoseMethodView: View {
    var body: some View{
        
        
        NavigationLink(destination: SignInView()) {
            HStack {
                Text("Have an account?")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.primary)
                
                Text("Log in")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.blue)
                
            }
        }
    }
}

struct LoginView: View {
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Login!")
                        .font(.system(size: 55))
                        .fontWeight(.heavy)
                        .padding(.leading)
                    
                    Spacer()
                }
                
                Spacer()
                
                NavigationLink(destination: SignUpView()) {
                    HStack(alignment: .center) {
                        
                        
                        Text("Sign up with Apple")
                            .frame(width: 310, height: 55)
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .bold))
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1))
                        
                    }
                }.padding(15)
                
                NavigationLink(destination: SignUpView()) {
                    HStack {
                        Text("Sign up with Google")
                            .frame(width: 310, height: 55)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .background(Color.red)
                            .cornerRadius(20)
                        
                    }
                }
                
                loginFB()
                    .frame(width: 310, height: 55)
                    .cornerRadius(20)
                
                Divider()
                
                NavigationLink(destination: SignUpView()) {
                    HStack {
                        Text("Create a new account")
                            .frame(width: 310, height: 55)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .background(Color.black)
                            .cornerRadius(20)
                        
                    }
                }
                
                NavigationLink(destination: SignInView()) {
                    HStack {
                        Text("Have an account?")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.primary)
                        
                        Text("Log in")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.blue)
                        
                    }
                }
            }.padding([.leading, .bottom, .trailing], 32)
        }
    }
}

struct loginFB: UIViewRepresentable{
    func makeCoordinator() -> loginFB.Coordinator {
        return loginFB.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<loginFB>) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<loginFB>) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate{
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                
                Auth.auth().signIn(with: credential) {(res, er) in
                    if er != nil {
                        print((er?.localizedDescription)!)
                        return
                    }
                    print("Success!")
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionStore())
    }
}
