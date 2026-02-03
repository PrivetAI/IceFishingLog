import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showAddSpecies = false
    @State private var newSpeciesName = ""
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("Settings")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Units section
                        unitsSection
                        
                        // Fish species section
                        fishSpeciesSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            
            // Add species overlay
            if showAddSpecies {
                addSpeciesOverlay
            }
        }
    }
    
    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Units")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
            
            VStack(spacing: 0) {
                // Weight unit
                HStack {
                    Text("Weight")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        unitButton(
                            title: "Grams",
                            isSelected: dataManager.weightUnit == .grams,
                            action: {
                                dataManager.weightUnit = .grams
                                dataManager.saveSettings()
                            }
                        )
                        
                        unitButton(
                            title: "Kilograms",
                            isSelected: dataManager.weightUnit == .kilograms,
                            action: {
                                dataManager.weightUnit = .kilograms
                                dataManager.saveSettings()
                            }
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.92, green: 0.94, blue: 0.96))
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                Divider()
                    .padding(.leading, 16)
                
                // Length unit
                HStack {
                    Text("Length")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        unitButton(
                            title: "cm",
                            isSelected: dataManager.lengthUnit == .centimeters,
                            action: {
                                dataManager.lengthUnit = .centimeters
                                dataManager.saveSettings()
                            }
                        )
                        
                        unitButton(
                            title: "inches",
                            isSelected: dataManager.lengthUnit == .inches,
                            action: {
                                dataManager.lengthUnit = .inches
                                dataManager.saveSettings()
                            }
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.92, green: 0.94, blue: 0.96))
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
        }
    }
    
    private func unitButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Color(red: 0.4, green: 0.45, blue: 0.55))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color(red: 0.2, green: 0.5, blue: 0.8) : Color.clear)
                )
        }
    }
    
    private var fishSpeciesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Fish Species")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                
                Spacer()
                
                Button(action: {
                    showAddSpecies = true
                }) {
                    HStack(spacing: 4) {
                        Text("+")
                            .font(.system(size: 16, weight: .medium))
                        Text("Add")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
            }
            
            VStack(spacing: 0) {
                let sortedSpecies = dataManager.fishSpecies.sorted { $0.name < $1.name }
                
                ForEach(Array(sortedSpecies.enumerated()), id: \.element.id) { index, species in
                    HStack {
                        Text(species.name)
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                        
                        Spacer()
                        
                        if !species.isDefault {
                            Button(action: {
                                dataManager.deleteSpecies(species)
                            }) {
                                Text("Remove")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                            }
                        } else {
                            Text("Default")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    if index < sortedSpecies.count - 1 {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
        }
    }
    
    private var addSpeciesOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showAddSpecies = false
                    newSpeciesName = ""
                }
            
            VStack(spacing: 20) {
                Text("Add Fish Species")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                
                CustomTextField(
                    title: "Species Name",
                    text: $newSpeciesName,
                    placeholder: "Enter species name"
                )
                
                HStack(spacing: 12) {
                    SecondaryButton(title: "Cancel") {
                        showAddSpecies = false
                        newSpeciesName = ""
                    }
                    
                    PrimaryButton(title: "Add", action: {
                        guard !newSpeciesName.isEmpty else { return }
                        let species = FishSpecies(name: newSpeciesName, isDefault: false)
                        dataManager.addSpecies(species)
                        newSpeciesName = ""
                        showAddSpecies = false
                    }, isWide: false)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            )
            .padding(.horizontal, 32)
        }
    }
}
