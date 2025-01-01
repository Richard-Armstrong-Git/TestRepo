import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let task: String
    var complete: Bool = false
}

struct ContentView: View {
    @State private var placeholderString: String = "Default"
    @State private var todoTasks: [Task] = [Task(task: "Zeros entry")]
    @State private var taskHolder: String = ""
    
    // Updated delete function to accept UUID
    func delete(task_id: UUID) {
        if let index = todoTasks.firstIndex(where: { $0.id == task_id }) {
            let deletedTask = todoTasks.remove(at: index)
            placeholderString = "Deleted Task: \(deletedTask.task)"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) { // Added spacing for better layout
            Text(placeholderString)
                .font(.headline)
                .padding()
            
            TextField(
                "Enter New Task",
                text: $taskHolder
            )
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            NavigationView {
                List {
                    ForEach(todoTasks) { task in
                        HStack {
                            Text(task.task)
                                .strikethrough(task.complete, color: .red)
                                .foregroundColor(task.complete ? .gray : .primary)
                            
                            Spacer()
                            
                            Button(action: {
                                if let index = todoTasks.firstIndex(where: { $0.id == task.id }) {
                                    todoTasks[index].complete.toggle()
                                }
                            }) {
                                Image(systemName: task.complete ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.complete ? .green : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                delete(task_id: task.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("To-Do List")
            }
            
            Button("Submit") {
                let trimmedTask = taskHolder.trimmingCharacters(in: .whitespaces)
                guard !trimmedTask.isEmpty else { return }
                todoTasks.append(Task(task: trimmedTask))
                taskHolder = ""
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
