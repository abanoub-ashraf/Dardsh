//
//  FCollectionReferences.swift
//  Dardsh
//
//  Created by Abanoub Ashraf on 26/09/2022.
//

import Foundation
import Firebase

///
/// for the name of each collection we gonna use
///
enum FCollectionReference: String {
    case User
}

///
/// to get the firestore collection we want use
///
func firestoreReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
