import Foundation

enum Genre: String, CaseIterable, Codable {
    case fiction = "Художественная литература"
    case nonFiction = "Нон-фикшн"
    case mystery = "Детектив"
    case sciFi = "Научная фантастика"
    case biography = "Биография"
    case fantasy = "Фэнтези"
}

struct Book: Identifiable, Codable {
    let id: String
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: Genre
    var tags: [String]
    
    init(id: String = UUID().uuidString,
         title: String,
         author: String,
         publicationYear: Int? = nil,
         genre: Genre,
         tags: [String] = []) {
        self.id = id
        self.title = title
        self.author = author
        self.publicationYear = publicationYear
        self.genre = genre
        self.tags = tags.map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
                        .filter { !$0.isEmpty }
    }
}

struct SearchQuery{
    let title: String?
    let author: String?
    let genre: Genre?
    let tag: String?
    let year: Int?
}
