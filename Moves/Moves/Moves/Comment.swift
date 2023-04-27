//
//  Comment.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase


struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    var body = ""
    var reviewer = ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["body": body, "reviewer": Auth.auth().currentUser?.email ?? "", "postedOn": Timestamp(date: Date())]
    }
}
