//
//  Move.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Move: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var upvotes = "2"
    var postedOn = Date()
    var postedBy = ""
    var description = ""
    
    
    var dictionary: [String: Any] {
        return ["name": name, "upvotes": upvotes, "postedOn": Timestamp(date: Date()), "description": description, "postedBy": Auth.auth().currentUser?.email ?? ""]
    }
    
}
