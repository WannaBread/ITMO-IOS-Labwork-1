import Foundation

protocol BookShelfProtocol {
    func add(_ book: Book) throws
    func delete(id: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) -> [Book]
    func save()
}
