//
//  NewEventMainView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/4/23.
//

import SwiftUI
import MessageUI

struct NewEventMainView: View {
    @State var eventName: String = ""
    @State var eventLocation: String = ""
    @State var eventTime: String = ""
    @State var eventInfo: String = ""
    @State var eventTasks: [Task] = []
    @State var eventInventory: [InventoryItem] = []
    @State var eventAttendees:[Attendee] = []
    
    
    
    @Binding var eventUpdateExists: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isShowingInviteView:Bool = false
    @State private var isShowingTasks:Bool = false
    @State private var isShowingInventory:Bool = false
    @State private var isShowingAttendees:Bool = false
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        NavigationView {
            ZStack {
                back.ignoresSafeArea()
                VStack {
                    Text("")
                        .navigationBarItems(leading:
                            Button(action: {
                                print(eventUpdateExists)
                                if (eventName != "" ||  eventLocation != "" || eventTime != "" || eventInfo != "" || eventTasks != [] || eventInventory != [] || eventAttendees != []) {
                                    let newEvent = Event(name: eventName, date: eventTime, location: eventLocation, notes: eventInfo, tasks: eventTasks, inventoryItems: eventInventory, attendees: eventAttendees)
                                    saveEventData(toSave: newEvent)
                                    print("Event Data Updated")
                                    eventUpdateExists = true
                                    print(eventUpdateExists)
                                    
                                    
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.blue)
                            }
                        )
                    
                    
                    ScrollView {
                        Spacer().frame(height:30)
                        Text("Create Your Event").font(.cursiveFont(size: 47)).shadow(radius: 5)
                        
                        Spacer().frame(height:30)
                        TextField("Event Name...", text: $eventName)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                    .shadow(radius: 5)
                        Spacer().frame(height:0)
                        HStack {
                            Spacer().frame(width:15)
                            TextField("Event Location...", text: $eventLocation)
                                        .textFieldStyle(.roundedBorder)
                                        .shadow(radius: 10)
                            Spacer().frame(width:15)
                            TextField("Event Time...", text: $eventTime)
                                        .textFieldStyle(.roundedBorder)
                                        .shadow(radius: 10)
                                    
                            Spacer().frame(width:15)
                        }
                        
                        Spacer().frame(height:25)

                        TextField("Event Details...", text: $eventInfo)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                    .shadow(radius: 10)
                        
                        Spacer().frame(height:30)
                        
                        VStack {
                            
                            HStack {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width:125,height:125)
                                        .padding()
                                        .foregroundColor(buttonColor)
                                        .shadow(radius: 10)
                                    Button("Attendees") {
                                        isShowingInviteView.toggle()
                                    }.foregroundColor(.black)
                                    .sheet(isPresented: $isShowingInviteView) {
                                        InvitationsSendView(invitees: $eventAttendees)
                                    }
                                }
                                
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width:125,height:125)
                                        .padding()
                                        .foregroundColor(buttonColor)
                                        .shadow(radius: 5)
                                    Button("Tasks") {
                                        isShowingTasks.toggle()
                                    }.foregroundColor(.black)
                                    .sheet(isPresented: $isShowingTasks) {
                                        EventTasksView(tasks: $eventTasks)
                                    }
                                }
                            }
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width:125,height:125)
                                        .padding()
                                        .foregroundColor(buttonColor)
                                        .shadow(radius: 5)
                                    Button("Inventory") {
                                        isShowingInventory.toggle()
                                    }.foregroundColor(.black)
                                        .sheet(isPresented: $isShowingInventory) {
                                            EventInventoryView(inventory: $eventInventory)
                                        }
                                }
                                
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width:125,height:125)
                                        .padding()
                                        .foregroundColor(buttonColor)
                                        .shadow(radius: 5)
                                    Button("Messages") {
                                        isShowingAttendees.toggle()
                                    }.foregroundColor(.black)
                                    .sheet(isPresented: $isShowingAttendees) {
                                        AttendeesListView(attendees: $eventAttendees)
                                    }
                                }
                                 
                            }
                        }
                    }
                }
                
            }

        }
        .interactiveDismissDisabled(true)
        .onAppear() {
            let checkerEvent = Event(name: eventName, date: eventTime, location: eventLocation, notes: eventInfo, tasks: eventTasks, inventoryItems: eventInventory, attendees: eventAttendees)
            
            removeEvent(checkerEvent)
            
        
        }
    }
    func updateEventAttendees(withAttendees attendees: [Attendee]) {
        eventAttendees = attendees
    }
}




/*
 struct NewEventMainView_Previews: PreviewProvider {
 @State var x = false
 static var previews: some View {
 NewEventMainView(eventUpdateExists: $x)
 }
 }
*/
