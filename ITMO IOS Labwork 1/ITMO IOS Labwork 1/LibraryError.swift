import Foundation

enum LibraryError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case notFound(id: String)
    case duplicateId(String)
    case saveFailed(String)
    case loadFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Название не может быть пустым"
        case .emptyAuthor:
            return "Автор не может быть пустым"
        case .invalidYear(let year):
            return "Некорректный год: \(year). Год должен быть в диапазоне 1400-2026"
        case .notFound(let id):
            return "Книга с id \(id) не найдена"
        case .duplicateId(let id):
            return "Книга с id \(id) уже существует"
        case .saveFailed(let reason):
            return "Не удалось сохранить данные: \(reason)"
        case .loadFailed(let reason):
            return "Не удалось загрузить данные: \(reason)"
        }
    }
}
