//
//  UserModel.swift
//  Dardsh
//
//  Created by Abanoub Ashraf on 26/09/2022.
//

import Foundation
///
/// this is necessary to be able to use the codable model with firebase
///
import FirebaseFirestoreSwift

///
/// to allow the user to be coded and decoded when needed
///
struct UserModel: Codable {
    var id = ""
    var username: String
    var email: String
    ///
    /// this will be used for sending notifications to the user in case the app was in background
    ///
    var pushId = ""
    ///
    /// this will point to the real image that's gonna be stored in firebase storage
    ///
    var avatarLink = ""
    var status = ""
}

func saveUserLocally(_ user: UserModel) {
    ///
    /// we need encoder cause we can't save objects in user defaults without encoding them first
    ///
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        userDefaults.set(data, forKey: CURRENT_USER)
    } catch {
        print(error.localizedDescription)
    }
}
