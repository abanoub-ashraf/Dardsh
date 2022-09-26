//
//  FUserListener.swift
//  Dardsh
//
//  Created by Abanoub Ashraf on 26/09/2022.
//

import Foundation
import Firebase

class FUserListener {
    
    static let shared = FUserListener()
    
    private init() {}
    
    func registerUserWith(email: String, password: String, onCompleted: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            ///
            /// if there's any error
            ///
            onCompleted(error)
            
            ///
            /// if no error then authResult has a value 100%
            ///
            if error == nil {
                ///
                /// send a verification email to the user after they sign up
                ///
                authResult!.user.sendEmailVerification { error in
                    onCompleted(error)
                }
            }
            
            ///
            /// now this is for creating a document for that user in firestore
            ///
            if authResult?.user != nil {
                let user = UserModel(
                    id: authResult!.user.uid,
                    username: email,
                    email: email,
                    pushId: "",
                    avatarLink: "",
                    status: "Hey, I am using Dardsh!"
                )
                
                self?.saveUserToFirestore(user)
                saveUserLocally(user)
            }
        }
    }
    
    func saveUserToFirestore(_ user: UserModel) {
        do {
            ///
            /// - the name of the document is gonna be the id of the user, because the document is the actual user data
            /// - setData(from: ) comes from the FirebaseFirestoreSwift taht we imported in the user model file
            ///
            try firestoreReference(.User).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
