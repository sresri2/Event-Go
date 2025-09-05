//
//  InvitationsView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/10/23.
//

import SwiftUI
import MessageUI

struct InvitationsSendView: View {
    @Binding var invitees: [Attendee]
        
    var body: some View {
        VStack {
            Text("Enter New Invitees by Email")
                .font(.title)
                .padding()
            
            VStack {
                Button("New Attendee") {
                    let newAttendee: Attendee = Attendee(email: "", status: "Invited")
                    invitees.append(newAttendee)
                }.padding()
                
                Spacer()
                
                if invitees.isEmpty {
                    Text("Add people to your event list! Invite them via the Messages tab.").font(.cursiveFont(size: 20))
                }
                else {
                    List {
                        ForEach(invitees) { task in
                            HStack {
                                TextField("New Attendee", text: $invitees[invitees.firstIndex(where: { $0.id == task.id })!].email)
                                    .textFieldStyle(.roundedBorder)
                                    .shadow(radius: 5)
                                    .padding()
                            }
                        }
                    }
                }
                Spacer()
                
            }
            
            Spacer()
        }
    }
}




/*
 struct InvitationsView_Previews: PreviewProvider {
 static var previews: some View {
 InvitationsSendView()
 }
 }
 */
