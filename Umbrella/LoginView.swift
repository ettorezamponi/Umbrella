//
//  LoginView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 29/03/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseStorage

//Login with email
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
            
        }.padding(.horizontal, 32)
    }
}

//Create account with email
struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    //per i dati inseriti nel DB
    @State var alert = false
    @State var picker = false
    @State var loading = false
    @State var imagedata : Data = .init(count: 0)
    @State var username: String = ""
    
    
    //Funzione per aggiungere i dati nel DB
    func loadData(){
        let userDictionary = [
            "username":self.username
        ]
        //collection su Firebase si chiamerà "userInfo"
        let docRef = Firestore.firestore().document("userInfo/\(UUID().uuidString)")
        print("setting data")
        docRef.setData(userDictionary){ (error) in
            if let error = error {
                print("error = \(error)")
            } else {
                print ("data upload successfully")
            }
        }
    }
    
    func CreateUserDB (username: String, imagedata: Data) {
        let db = Firestore.firestore()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser?.uid
        
        //problemi con l'unwrapping perchè uid risulta uguale a nil
        storage.child("profilepics").child(uid ?? "no UID").putData(imagedata, metadata: nil) { (_, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            storage.child("profilepics").child(uid ?? "no UID").downloadURL { (url, err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                db.collection("users").document(uid ?? "no UID").setData(["username": username, "image":"\(url!)", "uid": uid ?? "no uid avaiable"]) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                }
            }
        }
    }
    
    //struttura per gestire la scelta dell'immagine da uploadare
    struct Indicator : UIViewRepresentable {
        func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.startAnimating()
            return indicator
        }
        
        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) { }
    }
    
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
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
            }.padding(.vertical, 30)
            .sheet(isPresented: self.$picker, content: {
                ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
            })
            
            Button(action: signUp) {
                Text("Create Account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.black)
                    .cornerRadius(20)
            }.disabled(email.isEmpty || password.isEmpty)
            
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

//View
struct LoginView: View {
    var body: some View {
        NavigationView {
            
            VStack{

                Spacer()
                
//                HStack(alignment: .center) {
//                    Text("Sign up with Apple")
//                        .frame(width: 310, height: 60)
//                        .foregroundColor(.black)
//                        .font(.system(size: 16, weight: .bold))
//                        .background(Color.white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.black, lineWidth: 1))
//                    
//                }.padding(15)
                
                google()
                    .frame(width: 310, height: 60)
                    .cornerRadius(20)
//                    .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.black, lineWidth: 1))
//                    .background(Color.gray)
//                    .foregroundColor(.white)
//                    .cornerRadius(20)
                
                loginFB()
                    .frame(width: 310, height: 55)
                    .cornerRadius(20)
                    .padding(5)
                
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
                }.padding(5)
                
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
            }
            .padding([.leading, .bottom, .trailing], 32)
            .navigationBarTitle("Login")
        }
    }
}

//Google Login
struct google: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<google>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<google>) {
        
    }
}

//Facebook Login
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

//Funzione per scegliere l'immagine da uploadare
struct ImagePicker : UIViewControllerRepresentable {
    @Binding var picker : Bool
    @Binding var imagedata : Data

    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var parent : ImagePicker
        init(parent1 : ImagePicker) {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.45)
            self.parent.imagedata = data!
            self.parent.picker.toggle()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView().environmentObject(SessionStore())
            LoginView().environmentObject(SessionStore())
        }
    }
}
