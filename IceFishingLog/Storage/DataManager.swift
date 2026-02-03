import Foundation
import SwiftUI

enum WeightUnit: String, Codable, CaseIterable {
    case grams = "g"
    case kilograms = "kg"
    
    var displayName: String {
        switch self {
        case .grams: return "Grams"
        case .kilograms: return "Kilograms"
        }
    }
}

enum LengthUnit: String, Codable, CaseIterable {
    case centimeters = "cm"
    case inches = "in"
    
    var displayName: String {
        switch self {
        case .centimeters: return "Centimeters"
        case .inches: return "Inches"
        }
    }
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let catchesKey = "catches"
    private let speciesKey = "fishSpecies"
    private let weightUnitKey = "weightUnit"
    private let lengthUnitKey = "lengthUnit"
    
    @Published var catches: [Catch] = []
    @Published var fishSpecies: [FishSpecies] = []
    @Published var weightUnit: WeightUnit = .grams
    @Published var lengthUnit: LengthUnit = .centimeters
    
    private init() {
        loadData()
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        loadCatches()
        loadSpecies()
        loadSettings()
    }
    
    private func loadCatches() {
        guard let data = UserDefaults.standard.data(forKey: catchesKey) else {
            catches = []
            return
        }
        do {
            catches = try JSONDecoder().decode([Catch].self, from: data)
        } catch {
            catches = []
        }
    }
    
    private func loadSpecies() {
        guard let data = UserDefaults.standard.data(forKey: speciesKey) else {
            fishSpecies = DefaultFishSpecies.list
            saveSpecies()
            return
        }
        do {
            fishSpecies = try JSONDecoder().decode([FishSpecies].self, from: data)
        } catch {
            fishSpecies = DefaultFishSpecies.list
            saveSpecies()
        }
    }
    
    private func loadSettings() {
        if let weightRaw = UserDefaults.standard.string(forKey: weightUnitKey),
           let unit = WeightUnit(rawValue: weightRaw) {
            weightUnit = unit
        }
        if let lengthRaw = UserDefaults.standard.string(forKey: lengthUnitKey),
           let unit = LengthUnit(rawValue: lengthRaw) {
            lengthUnit = unit
        }
    }
    
    // MARK: - Data Saving
    
    private func saveCatches() {
        do {
            let data = try JSONEncoder().encode(catches)
            UserDefaults.standard.set(data, forKey: catchesKey)
        } catch {
            print("Failed to save catches")
        }
    }
    
    private func saveSpecies() {
        do {
            let data = try JSONEncoder().encode(fishSpecies)
            UserDefaults.standard.set(data, forKey: speciesKey)
        } catch {
            print("Failed to save species")
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(weightUnit.rawValue, forKey: weightUnitKey)
        UserDefaults.standard.set(lengthUnit.rawValue, forKey: lengthUnitKey)
    }
    
    // MARK: - Catch CRUD
    
    func addCatch(_ catchItem: Catch) {
        catches.append(catchItem)
        saveCatches()
    }
    
    func updateCatch(_ catchItem: Catch) {
        if let index = catches.firstIndex(where: { $0.id == catchItem.id }) {
            catches[index] = catchItem
            saveCatches()
        }
    }
    
    func deleteCatch(_ catchItem: Catch) {
        catches.removeAll { $0.id == catchItem.id }
        saveCatches()
    }
    
    func deleteCatch(at offsets: IndexSet, from catchList: [Catch]) {
        for index in offsets {
            let catchToDelete = catchList[index]
            catches.removeAll { $0.id == catchToDelete.id }
        }
        saveCatches()
    }
    
    // MARK: - Species CRUD
    
    func addSpecies(_ species: FishSpecies) {
        fishSpecies.append(species)
        saveSpecies()
    }
    
    func deleteSpecies(_ species: FishSpecies) {
        fishSpecies.removeAll { $0.id == species.id }
        saveSpecies()
    }
    
    // MARK: - Queries
    
    func catchesForDate(_ date: Date) -> [Catch] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return catches.filter { Calendar.current.startOfDay(for: $0.catchTime) == startOfDay }
            .sorted { $0.catchTime > $1.catchTime }
    }
    
    func todayCatches() -> [Catch] {
        catchesForDate(Date())
    }
    
    func allSessions() -> [(date: Date, catches: [Catch])] {
        let grouped = Dictionary(grouping: catches) { catchItem in
            Calendar.current.startOfDay(for: catchItem.catchTime)
        }
        return grouped.map { (date: $0.key, catches: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    // MARK: - Statistics
    
    func isIceFishingSeason(for date: Date) -> Bool {
        let month = Calendar.current.component(.month, from: date)
        // November (11), December (12), January (1), February (2), March (3)
        return month >= 11 || month <= 3
    }
    
    func currentSeasonCatches() -> [Catch] {
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // Determine season start year
        let seasonStartYear: Int
        if currentMonth >= 11 {
            seasonStartYear = currentYear
        } else {
            seasonStartYear = currentYear - 1
        }
        
        // Season: Nov 1 of seasonStartYear to Mar 31 of seasonStartYear+1
        var startComponents = DateComponents()
        startComponents.year = seasonStartYear
        startComponents.month = 11
        startComponents.day = 1
        
        var endComponents = DateComponents()
        endComponents.year = seasonStartYear + 1
        endComponents.month = 3
        endComponents.day = 31
        endComponents.hour = 23
        endComponents.minute = 59
        endComponents.second = 59
        
        guard let seasonStart = calendar.date(from: startComponents),
              let seasonEnd = calendar.date(from: endComponents) else {
            return []
        }
        
        return catches.filter { $0.catchTime >= seasonStart && $0.catchTime <= seasonEnd }
    }
    
    func daysOnIce() -> Int {
        let seasonCatches = currentSeasonCatches()
        let uniqueDays = Set(seasonCatches.map { Calendar.current.startOfDay(for: $0.catchTime) })
        return uniqueDays.count
    }
    
    func bestDay() -> (date: Date, count: Int, weight: Int)? {
        let sessions = allSessions()
        guard !sessions.isEmpty else { return nil }
        
        let best = sessions.max { session1, session2 in
            let weight1 = session1.catches.reduce(0) { $0 + $1.weight }
            let weight2 = session2.catches.reduce(0) { $0 + $1.weight }
            return weight1 < weight2
        }
        
        guard let bestSession = best else { return nil }
        let totalWeight = bestSession.catches.reduce(0) { $0 + $1.weight }
        return (date: bestSession.date, count: bestSession.catches.count, weight: totalWeight)
    }
    
    func speciesStats() -> [(species: String, count: Int, totalWeight: Int, biggest: Catch?)] {
        let grouped = Dictionary(grouping: catches) { $0.species }
        return grouped.map { species, catchList in
            let count = catchList.count
            let totalWeight = catchList.reduce(0) { $0 + $1.weight }
            let biggest = catchList.max { $0.weight < $1.weight }
            return (species: species, count: count, totalWeight: totalWeight, biggest: biggest)
        }.sorted { $0.totalWeight > $1.totalWeight }
    }
    
    func biggestCatchEver() -> Catch? {
        catches.max { $0.weight < $1.weight }
    }
    
    func mostFishInOneDay() -> (date: Date, count: Int)? {
        let sessions = allSessions()
        guard let best = sessions.max(by: { $0.catches.count < $1.catches.count }) else { return nil }
        return (date: best.date, count: best.catches.count)
    }
    
    // MARK: - Unit Conversion Helpers
    
    func displayWeight(_ grams: Int) -> String {
        switch weightUnit {
        case .grams:
            return "\(grams) g"
        case .kilograms:
            let kg = Double(grams) / 1000.0
            return String(format: "%.2f kg", kg)
        }
    }
    
    func displayLength(_ cm: Int) -> String {
        switch lengthUnit {
        case .centimeters:
            return "\(cm) cm"
        case .inches:
            let inches = Double(cm) / 2.54
            return String(format: "%.1f in", inches)
        }
    }
}
