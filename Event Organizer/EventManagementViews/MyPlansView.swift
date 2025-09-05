//
//  MyPlansView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/4/23.
//

import SwiftUI

struct MyPlansView: View {
    @State var isPresented = false
    @State var selectedEvent: Event?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var eventUpdateExists = false
    @State var updater = 0
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        let events = loadEventsData()
        
        ZStack {
            back.ignoresSafeArea()
            NavigationView {
                VStack {
                    Text("")
                        .navigationBarItems(leading:
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.blue)
                            }
                        )
                
                    Text("My Events").font(.cursiveFont(size: 40))
                    
                    if events.isEmpty {
                        Text("No Events Created Yet")
                    }
                    else {
                        
                        ScrollView {
                            ForEach(eventsDataArr.reversed(), id: \.id) { eventData in
                                NavigationLink(destination: NewEventMainView(eventName: eventData.name, eventLocation: eventData.location, eventTime: eventData.date, eventInfo: eventData.notes, eventTasks: eventData.tasks, eventInventory: eventData.inventoryItems, eventAttendees: eventData.attendees, eventUpdateExists: $eventUpdateExists).navigationBarBackButtonHidden(true), tag: eventData, selection: $selectedEvent) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).background(buttonColor).foregroundColor(buttonColor)
                                        Text(eventData.name)
                                            .background(buttonColor)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        
                    }
                        
                }
            }
        }
    }
}

struct MyPlansView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlansView()
    }
}
