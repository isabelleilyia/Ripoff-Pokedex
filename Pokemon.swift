import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: Sprite
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct Sprite: Codable {
    let front_default: String
}

struct PokemonListForDescriptions: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonDescription: Codable {
    let flavor_text_entries: [flavor_text_entry]
}

struct flavor_text_entry: Codable {
    let flavor_text: String
}


