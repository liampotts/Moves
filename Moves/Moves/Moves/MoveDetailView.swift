//
//  MoveDetailView.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct MoveDetailView: View {
    
    @EnvironmentObject var moveVM: MoveViewModel
    @State var move: Move
    
    //THIS IS ONE OF THE LINES THAT IS CAUSING THE ERROR
    @FirestoreQuery(collectionPath: "moves") var comments: [Comment]
    
    
    @Environment (\.dismiss) private var dismiss
    var previewRunning = false
    @State private var showCommentViewSheet = false
    @State private var showSaveAlert = false
    @State private var showingAsSheet = false
    
    //THIS IS JUST FROM ME TESTING
//    var comments: [Comment] = [Comment(body: "hi")]
    
    var body: some View {
        VStack {
            Text("Hamilton")
                .bold()
                .font(.title2)
            
            Text("\(move.upvotes) people going so far")
            
            VStack {
                Text("Guest List:")
                    .bold()
                    .font(.title2)
                    .padding()
                
                
                Button(action: {
                    if move.id == nil{
                        showSaveAlert.toggle()
                    } else {
                        showCommentViewSheet.toggle()
                    }
                }, label: {
                    Image(systemName: "star.fill")
                    Text("Add Comment")
                })
                
                Text("Comments:")
                    .bold()
                    .font(.title2)
                    .padding()
                
                //HERE IS WHERE I TRY TO LOAD COMMENTS
//                List(comments) { comment in
//                    NavigationLink{
////                        CommentView(move: move, comment: comment)
//                        TestView()
//                    } label: {
//                        Text(comment.body)
//                            .font(.title2)
//                    }
//                }
//                .listStyle(.plain)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onAppear {
            
            if !previewRunning && move.id != nil {
//                $comments.path = "moves/\(move.id ?? "")/comments"
//                print("reviews.path = \($comments.path)")
            } else { //spot.id starts out as nil
                showingAsSheet = true
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(move.id == nil)
        .toolbar {
            if showingAsSheet {
                if  move.id == nil && showingAsSheet { // New spot, so show Cancel/Save buttons
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            
                            Task {
                                let success = await moveVM.saveMove(move: move)
                                if success {
                                    dismiss()
                                    
                                } else {
                                    print("😡 DANG! Error saving spot!")
                                }
                            }
                            dismiss()
                        }
                    }
                    
                }
                else if showingAsSheet && move.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done"){
                            dismiss()
                        }
                    }
                }
            }
            
        }
        .sheet(isPresented: $showCommentViewSheet) {
            NavigationStack{
                CommentView(move: move, comment: Comment())
            }
        }
    }
}

struct MoveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoveDetailView(move: Move(), previewRunning: true)
                .environmentObject(MoveViewModel())
        }
    }
}
