import Foundation

struct Catch: Codable, Identifiable {
    let id: UUID
    var species: String
    var weight: Int // in grams
    var size: Int // in cm
    var catchTime: Date
    var notes: String?
    
    init(id: UUID = UUID(), species: String, weight: Int, size: Int, catchTime: Date = Date(), notes: String? = nil) {
        self.id = id
        self.species = species
        self.weight = weight
        self.size = size
        self.catchTime = catchTime
        self.notes = notes
    }
    
    var dateOnly: Date {
        Calendar.current.startOfDay(for: catchTime)
    }
}
