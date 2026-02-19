import Foundation

class BookShelf: BookShelfProtocol {
    private var books: [Book] = []
    private let fileURL: URL
    
    init() {
        let currentDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        self.fileURL = currentDir.appendingPathComponent("books.json")
        load()
    }
    
    
    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            books = try JSONDecoder().decode([Book].self, from: data)
            print("Загружено книг: \(books.count)")
        } catch {
            print("Не удалось загрузить данные: \(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(books)
            try data.write(to: fileURL)
        } catch {
            print("Не удалось сохранить данные: \(error.localizedDescription)")
        }
    }
        
    func add(_ book: Book) throws {
        try validateBook(book)
        if books.contains(where: {$0.id == book.id}){
            throw LibraryError.duplicateId(book.id)
        }
        books.append(book)
        save()
    }
    
    func delete(id: String) throws {
        if let i = books.firstIndex(where: {$0.id == id}){
            books.remove(at: i)
            save()
        }
        else{
            throw LibraryError.notFound(id: id)
        }
    }
    
    func list() -> [Book] {
        return books
    }
    
    func search(_ query: SearchQuery) -> [Book] {
        return books.filter { book in
            if let title = query.title, !book.title.localizedCaseInsensitiveContains(title) {
                return false
            }
            if let author = query.author, !book.author.localizedCaseInsensitiveContains(author) {
                return false
            }
            if let genre = query.genre, book.genre != genre {
                return false
            }
            if let tag = query.tag, !book.tags.contains(where: { $0.localizedCaseInsensitiveContains(tag) }) {
                return false
            }
            if let year = query.year, book.publicationYear != year {
                return false
            }
            return true
        }
    }
    
    func validateBook(_ book: Book) throws{
        if book.title.trimmingCharacters(in: .whitespaces).isEmpty {
            throw LibraryError.emptyTitle
        }
        if book.author.trimmingCharacters(in: .whitespaces).isEmpty {
            throw LibraryError.emptyAuthor
        }
        if let year = book.publicationYear, year < 1400 && year > Calendar.current.component(.year, from: Date()){
            throw LibraryError.invalidYear(year)
        }
    }
}
