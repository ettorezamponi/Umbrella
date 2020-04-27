//
//  EditProfileView.swift
//  Umbrella
//
//  Created by Ettore Zamponi on 24/04/2020.
//  Copyright © 2020 Ettore Zamponi. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct EditProfileView: View {
    @EnvironmentObject var session: SessionStore
    @State var error: String = ""
    @State var username: String = ""
    @State var name: String = ""
    @State var surname: String = ""
    @State var alert = false
    @State var picker = false
    @State var loading = false
    @State var done = false
    @State var imagedata : Data = .init(count: 0)
    @Environment(\.presentationMode) var presentationMode
    //to show fields during typing
    
    
    func CreateUserDB (username: String, name:String, surname:String, imagedata: Data) {
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
                db.collection("users").document(uid ?? "no UID").setData(["username": username, "name": name, "surname":surname, "image":"\(url!)", "uid": uid ?? "no uid avaiable"]) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                }
            }
        }
        done = true
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
    
    func upload() {
        CreateUserDB(username: self.username, name: self.name, surname: self.surname, imagedata: self.imagedata)
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack{
            Text("Modify your info")
                .font(.system(size: 40, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding(.top, 30.0)
            
            Button(action: {self.picker.toggle() }) {
                if self.imagedata.count == 0{
                    Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 150, height: 120).foregroundColor(.gray)
                }
                else{
                    Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 100, height: 150).clipShape(Circle())
                }
            }.padding(30)
            VStack{
                TextField("Username", text: $username)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                
                TextField("Name", text: $name)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                
                TextField("Surname", text: $surname)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
            }
            Spacer()
            
            Button(action: upload){
                Text("Save")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .background(Color.black)
                    .cornerRadius(20)
            }.disabled(username.isEmpty || name.isEmpty || surname.isEmpty)
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }.padding(.horizontal, 32)
            .sheet(isPresented: self.$picker, content: {
                ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
            })
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
