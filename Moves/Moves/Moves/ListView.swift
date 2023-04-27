//
//  ContentView.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "moves") var moves: [Move]

      
    
    @State private var sheetIsPresented = false
    @Environment (\.dismiss) private var dismiss
    var previewRunning = false
    
    var body: some View {
        VStack{
            NavigationStack {
                List(moves) { move in
                    NavigationLink {
                        MoveDetailView(move: move)
        
                    } label: {
                        Text(move.name)
                            .font(.title2)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Potential Moves 👀")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("Log out successful!")
                                dismiss()
                            } catch {
                                print("Error: could not sign out")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                    }
                    
                }
                .sheet(isPresented: $sheetIsPresented) {
                    NavigationStack{
                        AddMoveView(move: Move())
                    }
                }
            }
        }
        .onAppear{
                print("hi")
            print($moves.path)
        }
        
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ListView()
        }
    }
}
