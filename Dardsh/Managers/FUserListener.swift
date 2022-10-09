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
    
    ///
    /// extra param to inform the ui that the user's verified their email
    ///
    func loginUserWith(email: String, password: String, onCompleted: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil && authResult!.user.isEmailVerified {
                onCompleted(error, true)
                ///
                /// when wew login we need to get the user stored in firebase and save it locally
                ///
                self.downloadUserFromFirestore(userId: authResult!.user.uid)
            } else {
                onCompleted(error, false)
            }
        }
    }
    
    ///
    /// if the user wanna have a verification email again for some reason
    ///
    func resendVerificationEmailWith(email: String, onCompleted: @escaping (_ error: Error?) -> Void) {
        ///
        /// reload the current user data from the server first
        ///
        Auth.auth().currentUser?.reload(completion: { error in
            ///
            /// then send email verification to that user
            ///
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                onCompleted(error)
            })
        })
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
    
    private func downloadUserFromFirestore(userId: String) {
        firestoreReference(.User).document(userId).getDocument { document, error in
            guard let userDocument = document else {
                print("no data found")
                return
            }
            
            let result = Result {
                ///
                /// this is possible because the FirebaseFirestoreSwift pod we installed
                ///
                try? userDocument.data(as: UserModel.self)
            }
            
            switch result {
                case .success(let userObject):
                    if let user = userObject {
                        saveUserLocally(user)
                    } else {
                        print("document doesn't exist")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
