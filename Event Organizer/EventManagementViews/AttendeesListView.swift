//
//  AttendeesListView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/10/23.
//

import SwiftUI
import MessageUI

struct AttendeesListView: View {
    @Binding var attendees: [Attendee]
    @State var statusOptions: [String] = [""]
    @State private var isShowingMailView: Bool = false
    @State private var alertMessage = "IMPORTANT: Once you send out your announcement, via the Mail app, please ensure that your message has been sent to attendees, as it is possible for your message to remain in the Outbox if Mail is not configured properly on your device."
    @State private var showAlert: Bool = false
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        
        ZStack {
            back.ignoresSafeArea()
            VStack {
                HStack {
                    if (MFMailComposeViewController.canSendMail()) {
                        Button("Create Announcement") {
                            isShowingMailView.toggle()
                        }
                        .sheet(isPresented: $isShowingMailView) {
                            MailSendView(isShowing: $isShowingMailView, recievers: attendees.map { $0.email }, showAlert: $showAlert)

                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Mail Warning"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                }
                        }
                        
                        .padding()
                    }
                    else {
                        Text("There was an error opening your Mail view. Ensure that the iCloud Mail app is properly set up and configured to be able to send announcements via EventGo")
                            .padding()
                    }
                    
                }
                
                Spacer()
                if attendees.isEmpty {
                    Text("No Attendees Yet").font(.cursiveFont(size: 20))
                }
                else {
                    List {
                        ForEach(attendees,id:\.id) { attendee in
                            HStack {
                                Text($attendees[attendees.firstIndex(where: { $0.id == attendee.id })!].email.wrappedValue)
                                
                                Picker("", selection: $attendees[attendees.firstIndex(where: { $0.id == attendee.id })!].status) {
                                    Text("Invited").tag("Invited")
                                    Text("Accepted").tag("Accepted")
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct MailSendView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @State var recievers: [String]

    @Binding var showAlert: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailSendView>) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recievers)
        mailComposer.setSubject("Invitation to <My Event>")
        mailComposer.setMessageBody("Please join me for my event on <insert date and time> at <insert location>. RSVP required.", isHTML: false)
        return mailComposer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailSendView>) {
            if !uiViewController.isBeingPresented && !uiViewController.isBeingDismissed {
                showAlert = true
                
            }
        }


    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing, showAlert: $showAlert)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var showAlert: Bool

        init(isShowing: Binding<Bool>, showAlert: Binding<Bool>) {
            _isShowing = isShowing
            _showAlert = showAlert
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                self.isShowing = false
                self.showAlert = true
            }
        }
    }
}



/*
 struct AttendeesListView_Previews: PreviewProvider {
 static var previews: some View {
 AttendeesListView()
 }
 }
 */
