//
//  EventTasksView.swift
//  Event Organizer
//
//  Created by Sreesh Srinivasan on 5/9/23.
//

import SwiftUI

struct EventTasksView: View {
    @Binding var tasks: [Task]
    
    var body: some View {
        let back = Color(red: 0.75, green: 0.8, blue: 0.95)
        let buttonColor = Color(red: 0.7, green: 0.7, blue: 1.0)
        
        ZStack {
            back.ignoresSafeArea()
            VStack {
                Button("New Task") {
                    let newTask: Task = Task(name: "New Task",status: "Not Started")
                    tasks.append(newTask)
                }.padding()
                
                Spacer()
                
                if tasks.isEmpty {
                    Text("No Tasks Created Yet").font(.cursiveFont(size: 20))
                }
                else {
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                TextField("New Task", text: $tasks[tasks.firstIndex(where: { $0.id == task.id })!].name)
                                    .textFieldStyle(.roundedBorder)
                                    .shadow(radius: 5)
                                    .padding()
                                Picker("", selection: $tasks[tasks.firstIndex(where: { $0.id == task.id })!].status) {
                                    Text("Not Started").tag("Not Started")
                                    Text("In Progress").tag("In Progress")
                                    Text("Completed").tag("Completed")
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

/*
 struct EventTasksView_Previews: PreviewProvider {
 static var previews: some View {
 EventTasksView(tasks: $[])
 }
 }
 */
