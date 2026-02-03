import SwiftUI

struct AddCatchView: View {
    @ObservedObject var dataManager = DataManager.shared
    @Binding var isPresented: Bool
    
    @State private var selectedSpecies: FishSpecies?
    @State private var weightText: String = ""
    @State private var sizeText: String = ""
    @State private var catchTime: Date = Date()
    @State private var notes: String = ""
    @State private var showSpeciesPicker = false
    @State private var showTimePicker = false
    @State private var showSavedMessage = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Species picker
                        speciesSection
                        
                        // Weight and Size
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "Weight (\(dataManager.weightUnit.rawValue))",
                                text: $weightText,
                                keyboardType: .numberPad,
                                placeholder: "Enter weight"
                            )
                            
                            CustomTextField(
                                title: "Size (\(dataManager.lengthUnit.rawValue))",
                                text: $sizeText,
                                keyboardType: .numberPad,
                                placeholder: "Enter size"
                            )
                        }
                        
                        // Time picker
                        timeSection
                        
                        // Notes
                        CustomTextEditor(
                            title: "Notes (optional)",
                            text: $notes,
                            placeholder: "e.g. bottom, 3m depth, jig..."
                        )
                        
                        // Save button
                        PrimaryButton(title: "Save Catch", action: saveCatch)
                            .padding(.top, 10)
                        
                        // Add another text
                        if showSavedMessage {
                            Text("Saved! Add another catch or close")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.4))
                                .transition(.opacity)
                        }
                    }
                    .padding(20)
                }
            }
            
            // Species picker overlay
            if showSpeciesPicker {
                speciesPickerOverlay
            }
            
            // Time picker overlay
            if showTimePicker {
                timePickerOverlay
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            }
            
            Spacer()
            
            Text("Add Catch")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
            
            Spacer()
            
            // Invisible balance
            Text("Close")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var speciesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Fish Species")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
            
            Button(action: {
                showSpeciesPicker = true
            }) {
                HStack {
                    Text(selectedSpecies?.name ?? "Select species")
                        .font(.system(size: 16))
                        .foregroundColor(selectedSpecies != nil ?
                            Color(red: 0.1, green: 0.15, blue: 0.25) :
                            Color(red: 0.6, green: 0.65, blue: 0.7))
                    
                    Spacer()
                    
                    Text("▼")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.85, green: 0.88, blue: 0.92), lineWidth: 1)
                )
            }
        }
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Catch Time")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
            
            Button(action: {
                showTimePicker = true
            }) {
                HStack {
                    Text(timeFormatter.string(from: catchTime))
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    
                    Spacer()
                    
                    Text("⏱")
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.85, green: 0.88, blue: 0.92), lineWidth: 1)
                )
            }
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var speciesPickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showSpeciesPicker = false
                }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Select Species")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    
                    Spacer()
                    
                    Button("Done") {
                        showSpeciesPicker = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                .padding(16)
                
                Divider()
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(dataManager.fishSpecies.sorted { $0.name < $1.name }) { species in
                            Button(action: {
                                selectedSpecies = species
                                showSpeciesPicker = false
                            }) {
                                HStack {
                                    Text(species.name)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                                    
                                    Spacer()
                                    
                                    if selectedSpecies?.id == species.id {
                                        Circle()
                                            .fill(Color(red: 0.2, green: 0.5, blue: 0.8))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(20)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
        }
    }
    
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showTimePicker = false
                }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Select Time")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    
                    Spacer()
                    
                    Button("Done") {
                        showTimePicker = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                .padding(16)
                
                Divider()
                
                DatePicker("", selection: $catchTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(20)
        }
    }
    
    private func saveCatch() {
        guard let species = selectedSpecies else { return }
        
        let weight: Int
        let size: Int
        
        if dataManager.weightUnit == .kilograms {
            weight = Int((Double(weightText) ?? 0) * 1000)
        } else {
            weight = Int(weightText) ?? 0
        }
        
        if dataManager.lengthUnit == .inches {
            size = Int((Double(sizeText) ?? 0) * 2.54)
        } else {
            size = Int(sizeText) ?? 0
        }
        
        guard weight > 0 && size > 0 else { return }
        
        let newCatch = Catch(
            species: species.name,
            weight: weight,
            size: size,
            catchTime: catchTime,
            notes: notes.isEmpty ? nil : notes
        )
        
        dataManager.addCatch(newCatch)
        
        // Reset form for next entry
        weightText = ""
        sizeText = ""
        notes = ""
        catchTime = Date()
        
        withAnimation {
            showSavedMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSavedMessage = false
            }
        }
    }
}
