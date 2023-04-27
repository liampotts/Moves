//
//  CommentView.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CommentView: View {
    @State var move: Move
    @State var comment: Comment
    @Environment (\.dismiss) private var dismiss
    @StateObject var commentVM = CommentViewModel()
    @State var postedByThisUser = true
    @State var editOrCommenterString = "Click to edit:"
    
    var body: some View {
        VStack{
            VStack (alignment: .center){
                
                Text(move.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(move.upvotes + " upvotes")
                
                Text(editOrCommenterString)
                    .font(postedByThisUser ? .title2 : .subheadline)
                    .bold(postedByThisUser)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal)
                
                VStack (alignment: .leading){
                    Text("Comment")
                        .bold()
                    
                    TextField("comment", text: $comment.body, axis: .vertical)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: 250, alignment: .topLeading)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                        }
                }
                .disabled(!postedByThisUser)
                .padding(.horizontal)
                .font(.title2)
                
                
                
            }
            
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
        }
        .onAppear{
            if comment.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let commentPostedOn = comment.postedOn.formatted(date: .numeric, time: .omitted)
                editOrCommenterString = "by: \(comment.reviewer) on: \(commentPostedOn)"
            }
        }
        .navigationBarBackButtonHidden(postedByThisUser)
        .toolbar {
            if postedByThisUser{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem( placement: .navigationBarTrailing) {
                    Button("Save"){
                        Task{
                            let success = await commentVM.saveComment(move: move, comment: comment)
                            if success{
                                dismiss()
                            } else {
                                print("😡 ERROR saving data in CommentView")
                            }
                            
                        }
                        
                    }
                }
                
                if comment.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task {
                                let success = await commentVM.deleteComment(move: move, comment: comment)
                                if success {
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
        }
     
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CommentView(move: Move(name: "Game On", upvotes: "3", postedOn: Date()), comment: Comment())
        }
    }
}
