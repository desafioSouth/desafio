import Foundation

// MARK: - CardListModel
struct CardListModel: Codable {
    let cards: [Card]?
}

// MARK: - Card
struct Card: Codable {
    let name, manaCost: String?
    let cmc: Int?
    let colors, colorIdentity: [String]?
    let type: String?
    let types, subtypes: [String]?
    let rarity, cardSet, setName, text: String?
    let artist, number, power, toughness: String?
    let layout, multiverseid: String?
    let imageURL: String?
    let variations: [String]?
    let foreignNames: [ForeignName]?
    let printings: [String]?
    let originalText, originalType: String?
    let legalities: [LegalityElement]?
    let id, flavor: String?
    
    enum CodingKeys: String, CodingKey {
        case name, manaCost, cmc, colors, colorIdentity, type, types, subtypes, rarity
        case cardSet = "set"
        case setName, text, artist, number, power, toughness, layout, multiverseid
        case imageURL = "imageUrl"
        case variations, foreignNames, printings, originalText, originalType, legalities, id, flavor
    }
}

// MARK: - ForeignName
struct ForeignName: Codable {
    let name, text, type, flavor: String?
    let imageURL: String?
    let language: String?
    let multiverseid: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, text, type, flavor
        case imageURL = "imageUrl"
        case language, multiverseid
    }
}

// MARK: - LegalityElement
struct LegalityElement: Codable {
    let format: String?
    let legality: LegalityEnum?
}

enum LegalityEnum: String, Codable {
    case legal = "Legal"
}
