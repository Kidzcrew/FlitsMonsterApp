import SwiftUI
import SwiftData

struct WoordenLijstView: View {
    @Bindable var lijst: Lijst

    var body: some View {
        WoordLijst(lijst: lijst)
    }
}

private struct WoordLijst: View {
    @Bindable var lijst: Lijst
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext // For model operations
    @State private var isWoordEditorPresented = false
    @State private var woordToEdit: Woord? = nil

    var body: some View {
        VStack(alignment: .leading) {
            // Image and title area
            HStack(alignment: .top) {
                // List icon
                Image(lijst.icoon)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(maxWidth: 180, maxHeight: 160)

                LijstActionsView(lijst: lijst)
            }
            .padding(15)

            // Description
            Text(lijst.beschrijving)
                .font(.title2)
                .foregroundColor(.gray)
                .padding([.leading, .trailing, .bottom])
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            // List of words
            List {
                Text("Woorden:")
                    .font(.title2)
                    .bold()

                ForEach(lijst.woorden, id: \.id) { woord in
                    HStack {
                        Text(woord.naam)
                            .strikethrough(!woord.isActive) // Strikethrough for inactive words
                            .foregroundColor(woord.isActive ? .primary : .gray) // Gray out inactive words

                        Spacer()

                        // Show bookmark icon if the word is bookmarked
                        if woord.isBookmarked {
                            Image(systemName: "bookmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            // Show practice state dots if the word is not bookmarked
                            PracticeDotsView(woord: woord)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        // Swipe to toggle active/inactive (Archive)
                        Button {
                            toggleWoordActive(woord)
                        } label: {
                            Label(woord.isActive ? "Deactivate" : "Activate", systemImage: woord.isActive ? "xmark.circle" : "checkmark.circle")
                        }
                        .tint(woord.isBookmarked ? .gray : (woord.isActive ? .orange : .green)) // Gray if bookmarked
                        .disabled(woord.isBookmarked) // Disable if the word is bookmarked

                        // Swipe to delete
                        Button(role: .destructive) {
                            deleteWoord(woord)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        // Swipe to edit
                        Button {
                            woordToEdit = woord
                            isWoordEditorPresented = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .leading) {
                        // Swipe to bookmark/unbookmark
                        Button {
                            toggleBookmark(woord)
                        } label: {
                            Label(woord.isBookmarked ? "Unbookmark" : "Bookmark", systemImage: "bookmark.fill")
                        }
                        .tint(woord.isActive ? .yellow : .gray) // Gray out bookmark if inactive
                        .disabled(!woord.isActive) // Disable bookmark action if inactive
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .sheet(isPresented: $isWoordEditorPresented) {
            if let woordToEdit = woordToEdit {
                WoordEditor(woord: woordToEdit, lijst: lijst, woorden: $lijst.woorden)
            }
        }
        .navigationTitle(lijst.naam)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }

    // Delete word function
    private func deleteWoord(_ woord: Woord) {
        withAnimation {
            modelContext.delete(woord)
        }
    }

    // Toggle active/inactive function
    private func toggleWoordActive(_ woord: Woord) {
        withAnimation {
            woord.isActive.toggle()
        }
    }

    // Toggle bookmark function
    private func toggleBookmark(_ woord: Woord) {
        withAnimation {
            woord.isBookmarked.toggle() // Toggle bookmark status
        }
    }
}

// View to display 5 practice dots
private struct PracticeDotsView: View {
    let woord: Woord

    var body: some View {
        HStack(spacing: 4) {
            practiceDot(for: Woord.PracticeState(rawValue: woord.practice5) ?? .new)
            practiceDot(for: Woord.PracticeState(rawValue: woord.practice4) ?? .new)
            practiceDot(for: Woord.PracticeState(rawValue: woord.practice3) ?? .new)
            practiceDot(for: Woord.PracticeState(rawValue: woord.practice2) ?? .new)
            practiceDot(for: Woord.PracticeState(rawValue: woord.practice1) ?? .new)
        }
    }

    // Helper to generate the correct practice dot based on its state
    private func practiceDot(for state: Woord.PracticeState) -> some View {
        let color: Color
        let systemImage: String
        
        switch state {
        case .new:
            color = .gray
            systemImage = "circle.dotted"
        case .slow:
            color = .yellow
            systemImage = "circle.dashed.inset.fill"
        case .morePractice:
            color = .orange
            systemImage = "dot.circle.fill"
        case .known:
            color = .green
            systemImage = "circle.fill"
        }

        return Image(systemName: systemImage)
            .foregroundColor(color)
    }
}

struct LijstActionsView: View {
    @Bindable var lijst: Lijst
    @State private var isLijstEditorPresented = false
    @State private var isVoortgangSheetPresented = false
    @Environment(\.modelContext) private var modelContext // Get the model context for deletion
    @State private var isDeleteConfirmationPresented = false // For delete confirmation
    @Environment(\.dismiss) private var dismiss // To dismiss the current view

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Row 1: Niveau
            HStack {
                Image(systemName: "chart.bar") // SF icon for niveau
                Text("Niveau: \(lijst.niveau?.rawValue ?? "E3")")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            // Row 2: Edit List
            HStack {
                Image(systemName: "pencil") // SF icon for editing
                Button("Bewerk lijst") {
                    isLijstEditorPresented = true
                }
                .foregroundColor(.blue)
            }

            // Row 3: View Stats
            HStack {
                Image(systemName: "chart.pie") // SF icon for stats
                Button("Bekijk stats") {
                    isVoortgangSheetPresented = true
                }
                .foregroundColor(.blue)
            }

            // Row 4: Delete List
            HStack {
                Image(systemName: "trash") // SF icon for delete
                Button("Verwijder lijst") {
                    isDeleteConfirmationPresented = true // Trigger confirmation before deleting
                }
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        )
        .sheet(isPresented: $isLijstEditorPresented) {
            LijstEditor(lijst: lijst)
        }
        .sheet(isPresented: $isVoortgangSheetPresented) {
            LijstVoortgangView(lijst: lijst)
        }
        // Action sheet for delete confirmation
        .confirmationDialog("Weet je zeker dat je deze lijst wilt verwijderen?", isPresented: $isDeleteConfirmationPresented, titleVisibility: .visible) {
            Button("Verwijder", role: .destructive) {
                deleteLijst() // Perform the delete action
            }
            Button("Annuleer", role: .cancel) {}
        }
    }

    // Function to delete the lijst and dismiss the current view
    private func deleteLijst() {
        modelContext.delete(lijst) // Delete the lijst from the context
        print("Lijst deleted: \(lijst.naam)")
        dismiss() // Dismiss the view to go back to the previous screen
    }
}

// LijstVoortgangView to show stats for the list
private struct LijstVoortgangView: View {
    let lijst: Lijst
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Voortgang van de lijst \(lijst.naam)")
                .font(.title)
                .padding()

            Text("Aantal resterende woorden: \(lijst.woorden.count)")
                .font(.headline)

            Spacer()

            Button("Sluiten") {
                dismiss()
            }
            .padding()
        }
        .padding()
    }
}

#Preview("WoordenLijstView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            WoordenLijstView(lijst: Lijst(naam: "Voorbeeld lijst", isFavoriet: false, taal: .nl))
        }
    }
}
