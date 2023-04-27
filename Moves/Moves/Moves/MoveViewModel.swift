//
//  MoveViewModel.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import Foundation
import FirebaseFirestore
import Firebase

@MainActor

class MoveViewModel: ObservableObject {
    @Published var move = Move()
    
    func saveMove(move: Move) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = move.id {
            do {
                try await db.collection("moves").document(id).setData(move.dictionary)
                print("😎 Data updated successfully")
                return true
            } catch {
                print("😡 ERROR: could not update data in 'moves ")
                return false
            }
            
        } else {
            do {
              _ =  try await db.collection("moves").addDocument(data: move.dictionary)
                print("😎 Data added successfully")
                return true
            } catch {
                print("😡 ERROR: Could not create new move in 'moves")
                return false
            }
        }
    }
}
