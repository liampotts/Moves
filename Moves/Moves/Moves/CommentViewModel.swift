
import Foundation
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

@MainActor

class CommentViewModel: ObservableObject {
    @Published var comment = Comment()
    
    func saveComment(move: Move, comment: Comment) async -> Bool {
        let db = Firestore.firestore() // ignore error
        
        
        guard let moveID = move.id else {
            print("😡 ERROR: spot.id = nil")
            return false
        }
        let collectionString = "moves/\(moveID)/comments"
        
        if let id = comment.id {
            do {
                try await db.collection(collectionString).document(id).setData(comment.dictionary)
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print(" 😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else {
            
            do {
               _ = try await db.collection(collectionString).addDocument(data: comment.dictionary)
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteComment(move: Move, comment: Comment) async -> Bool {
        let db = Firestore.firestore()
        guard let moveID = move.id , let commentID = comment.id else {
            print ("😡 ERROR: moveID = \(move.id ?? "nil") commentID = \(comment.id ?? "nil") This should not have happened")
            return false
        }
        
        do {
            let _ = try await db.collection("moves").document(moveID).collection("comments").document(commentID).delete()
            print("🗑️ Document successfully deleted")
            return true
        } catch {
            print("😡 ERROR: removing document: \(error.localizedDescription)")
            return false
        }
    }
}

