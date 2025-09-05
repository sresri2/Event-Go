//
//  EventInventoryView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/9/23.
//

import SwiftUI

struct EventInventoryView: View {
    @Binding var inventory: [InventoryItem]
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        
        ZStack {
            back.ignoresSafeArea()
            VStack {
                Button("New Item") {
                    var newItem: InventoryItem = InventoryItem(name: "New Item", quantity: "0", quantityNeeded: "0")
                    inventory.append(newItem)
                }.padding()
                
                Spacer()
                
                if inventory.isEmpty {
                    Text("No Items Yet").font(.cursiveFont(size: 20))
                }
                else{
                    List {
                        HStack {
                        }
                        ForEach(inventory) { item in
                            HStack {
                                TextField("New Item", text: $inventory[inventory.firstIndex(where: { $0.id == item.id })!].name)
                                    .textFieldStyle(.roundedBorder)
                                    .shadow(radius: 5)
                                    .padding()
                                
                                Spacer()
                                TextField("Have", text: $inventory[inventory.firstIndex(where: { $0.id == item.id })!].quantity)
                                    .textFieldStyle(.roundedBorder)
                                    .shadow(radius: 5)
                                    .frame(width:90)
                                    .padding()
                                
                                TextField("Need", text: $inventory[inventory.firstIndex(where: { $0.id == item.id })!].quantityNeeded)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                    .shadow(radius: 5)
                                    .frame(width:90)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

/*
 struct EventInventoryView_Previews: PreviewProvider {
     @State var inv = InventoryItem(name: "New Item", quantity: "0", quantityNeeded: "0")
     static var previews: some View {
         EventInventoryView(inventory: $inv)
     }
 }
 */
 
