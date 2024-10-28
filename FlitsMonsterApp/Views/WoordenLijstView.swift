import SwiftUI
import SwiftData

struct WoordenLijstView: View {
    @Bindable var lijst: Lijst
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var isWoordEditorPresented = false
    @State private var woordToEdit: Woord?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(lijst.icoon)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(maxWidth: 180, maxHeight: 160)

                LijstActionsView(lijst: lijst)
            }
            .padding(15)

            Text(lijst.beschrijving)
                .font(.title2)
                .foregroundColor(.gray)
                .padding([.leading, .trailing, .bottom])
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            List {
                Text("Woorden:")
                    .font(.title2)
                    .bold()

                ForEach(lijst.woorden, id: \.id) { woord in
                    HStack {
                        Text(woord.naam)
                            .strikethrough(!woord.isActive)
                            .foregroundColor(woord.isActive ? .primary : .gray)

                        Spacer()

                        if woord.isBookmarked {
                            Image(systemName: "bookmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            PracticeDotsView(woord: woord)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            toggleWoordActive(woord)
                        } label: {
                            Label(woord.isActive ? "Deactivate" : "Activate", systemImage: woord.isActive ? "xmark.circle" : "checkmark.circle")
                        }
                        .tint(woord.isBookmarked ? .gray : (woord.isActive ? .orange : .green))
                        .disabled(woord.isBookmarked)

                        Button(role: .destructive) {
                            deleteWoord(woord)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            withAnimation {
                                woordToEdit = woord
                                isWoordEditorPresented = true
                            }
                            print("Edit button tapped. woordToEdit: \(woord.naam), isWoordEditorPresented: \(isWoordEditorPresented)")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            toggleBookmark(woord)
                        } label: {
                            Label(woord.isBookmarked ? "Unbookmark" : "Bookmark", systemImage: "bookmark.fill")
                        }
                        .tint(woord.isActive ? .yellow : .gray)
                        .disabled(!woord.isActive)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())

            if isWoordEditorPresented, let woord = woordToEdit {
                WoordEditorInline(woord: woord, lijst: lijst) { updatedWoord in
                    if let index = lijst.woorden.firstIndex(where: { $0.id == updatedWoord.id }) {
                        lijst.woorden[index] = updatedWoord
                    } else {
                        lijst.woorden.append(updatedWoord)
                    }
                    withAnimation {
                        isWoordEditorPresented = false
                        woordToEdit = nil
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity)) // Move up from bottom with fade
                .animation(.easeInOut(duration: 0.3), value: isWoordEditorPresented) // Smooth transition
                .padding()
            }
        }
        .navigationTitle(lijst.naam)
    }

    private func deleteWoord(_ woord: Woord) {
        withAnimation {
            modelContext.delete(woord)
        }
    }

    private func toggleWoordActive(_ woord: Woord) {
        withAnimation {
            woord.isActive.toggle()
        }
    }

    private func toggleBookmark(_ woord: Woord) {
        withAnimation {
            woord.isBookmarked.toggle()
        }
    }
}

// Inline WoordEditor View for editing within the list view
struct WoordEditorInline: View {
    var woord: Woord
    let lijst: Lijst
    var onSave: (Woord) -> Void
    
    @State private var naam = ""
    @State private var woordSoort = Woord.Soort.letterdief
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            TextField("Naam", text: $naam)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Woordsoort", selection: $woordSoort) {
                ForEach(Woord.Soort.allCases, id: \.self) { soort in
                    Text(soort.rawValue).tag(soort)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Bewaar") {
                let updatedWoord = woord
                updatedWoord.naam = naam
                updatedWoord.soort = woordSoort
                onSave(updatedWoord)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onAppear {
            naam = woord.naam
            woordSoort = woord.soort
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

    private func practiceDot(for state: Woord.PracticeState) -> some View {
        let color: Color
        let systemImage: String
        
        switch state {
        case .new:
            color = .gray
            systemImage = "circle.dotted"
        case .slow:
            color = .yellow
            systemImage = "circle.fill"
        case .morePractice:
            color = .orange
            systemImage = "circle.fill"
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
    @Environment(\.modelContext) private var modelContext
    @State private var isDeleteConfirmationPresented = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar")
                Text("Niveau: \(lijst.niveau?.rawValue ?? "E3")")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            HStack {
                Image(systemName: "pencil")
                Button("Bewerk lijst") {
                    isLijstEditorPresented = true
                }
                .foregroundColor(.blue)
            }
            HStack {
                Image(systemName: "chart.pie")
                Button("Bekijk stats") {
                    isVoortgangSheetPresented = true
                }
                .foregroundColor(.blue)
            }
            HStack {
                Image(systemName: "trash")
                Button("Verwijder lijst") {
                    isDeleteConfirmationPresented = true
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
        .confirmationDialog("Weet je zeker dat je deze lijst wilt verwijderen?", isPresented: $isDeleteConfirmationPresented, titleVisibility: .visible) {
            Button("Verwijder", role: .destructive) {
                deleteLijst()
            }
            Button("Annuleer", role: .cancel) {}
        }
    }

    private func deleteLijst() {
        modelContext.delete(lijst)
        print("Lijst deleted: \(lijst.naam)")
        dismiss()
    }
}

struct LijstVoortgangView: View {
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
