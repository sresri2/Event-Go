//
//  ContentView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 4/30/23.
//

import SwiftUI

extension Font {
    static func cursiveFont(size: CGFloat) -> Font {
        return Font.custom("Snell Roundhand", size: size)
    }
}

struct ContentView: View {
    @State private var newEventCreated: Bool = false
    @State private var viewingPlans:Bool = false
    @State private var eventUpdateExists = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        NavigationView {
            ZStack {
                back.ignoresSafeArea()
                VStack {
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20.0).frame(height: 50).padding().foregroundColor(buttonColor)
                            
                            Button(action: {
                                newEventCreated = true
                                
                                
                            }, label: {
                                Text("New Event")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(buttonColor)
                                    .cornerRadius(20)
                            })
                            
                            NavigationLink(destination: NewEventMainView(eventName: "Unnamed Event",eventLocation: "", eventTime: "", eventInfo:"",eventTasks: [],eventInventory: [], eventAttendees: [], eventUpdateExists: $eventUpdateExists) .navigationBarBackButtonHidden(true), isActive: $newEventCreated) {
                                EmptyView()
                            }
                            
                        }
                        
                        Spacer()
                        
                    }
                    Text("EventGo").font(.cursiveFont(size: 57))
                    HStack {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20.0).frame(height: 50).padding().foregroundColor(buttonColor)
                            Button(action: {
                                viewingPlans = true
                            }) {
                                Text("My Plans")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(buttonColor)
                                    .cornerRadius(20)
                            }
                            NavigationLink(destination: MyPlansView().navigationBarBackButtonHidden(true), isActive: $viewingPlans) {
                                EmptyView()
                            }
                        }
                    }
                    /*
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20.0).frame(height: 50).padding().foregroundColor(buttonColor)
                            Button(action: {
                                // action to perform when button is pressed
                            }) {
                                Text("TBD")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(buttonColor)
                                    .cornerRadius(20)
                            }
                        }
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 20.0).frame(height: 50).padding().foregroundColor(buttonColor)
                            Button(action: {
                                // action to perform when button is pressed
                            }) {
                                Text("TBD")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(buttonColor)
                                    .cornerRadius(20)
                            }
                        }
                    }
                     */

                }
                .padding()
                .background(back)
                .ignoresSafeArea()
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
