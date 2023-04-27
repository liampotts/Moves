//
//  MoveDetailView.swift
//  Moves
//
//  Created by Liam Potts on 4/22/23.
//

import SwiftUI

struct AddMoveView: View {
    @EnvironmentObject var moveVM: MoveViewModel
    @State var move: Move
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            Text("Enter A New Move:")
                .bold()
                .font(.title2)
            Group {
                TextField("Where are we going tonight?", text: $move.name)
                    .font(.title2)
                
                TextField("Description", text: $move.description, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .disabled(move.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: move.id == nil ? 2 : 0)
            }
            .padding(.horizontal)
            
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(move.id == nil)
        .toolbar {
            if move.id == nil { //new move so should show cancel/save
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        Task{
                            let success = await moveVM.saveMove(move: move)
                            if success {
                                dismiss()
                            } else {
                                print("Error saving spot")
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct MoveDetailView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack{
                AddMoveView(move: Move())
                    .environmentObject(MoveViewModel())
            }
        }
    }
}
