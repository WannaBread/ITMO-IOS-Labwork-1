import Foundation

class CLI {
    private let bookShelf: BookShelfProtocol
    
    init(bookShelf: BookShelfProtocol) {
        self.bookShelf = bookShelf
    }
    
    func run() {
        print("Команды: добавить | удалить | список | поиск | выход\n")
        
        var shouldExit = false
        
        while !shouldExit {
            print("Введите команду: ", terminator: "")
            guard let command = readLine()?.lowercased().trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            switch command {
            case "добавить":
                addBook()
            case "удалить":
                deleteBook()
            case "список":
                listBooks()
            case "поиск":
                searchBooks()
            case "выход":
                shouldExit = true
                bookShelf.save()
                print("До свидания!")
            default:
                print("Неизвестная команда\n")
            }
        }
    }
    
    private func addBook() {
        print("\nДобавление книги")
        
        print("Название: ", terminator: "")
        let title = readLine()
      
        
        print("Автор: ", terminator: "")
        let author = readLine()
        
        print("Год (или Enter для пропуска): ", terminator: "")
        let yearInput = readLine()
        let year = yearInput?.isEmpty == false ? Int(yearInput!) : nil
        
        print("Жанр (1-fiction, 2-nonFiction, 3-mystery, 4-sciFi, 5-biography, 6-fantasy): ", terminator: "")
        let genreInput = Int(readLine() ?? "1") ?? 1
        let genres = Genre.allCases
        let genre = genres[min(max(0, genreInput - 1), genres.count - 1)]
        
        print("Теги: ", terminator: "")
        let tagsInput = readLine() ?? ""
        let tags = tagsInput.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        
        let book = Book(title: title ?? "", author: author ?? "", publicationYear: year, genre: genre, tags: tags)
        
        do {
            try bookShelf.add(book)
            print("Книга добавлена! ID: \(book.id)\n")
        } catch {
            print("Ошибка: \(error.localizedDescription)\n")
        }
    }
    
    private func deleteBook() {
        print("\nУдаление книги")
        print("ID книги: ", terminator: "")
        guard let id = readLine()?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        do {
            try bookShelf.delete(id: id)
            print("Книга удалена\n")
        } catch {
            print("Ошибка: \(error.localizedDescription)\n")
        }
    }
    
    private func listBooks() {
        let books = bookShelf.list()
        print("\nВсего книг: \(books.count)")
        print(String(repeating: "─", count: 60))
        
        if books.isEmpty {
            print("Библиотека пуста\n")
            return
        }
        
        for book in books {
            printBook(book)
        }
        print()
    }
    
    private func searchBooks() {
        print("\nПоиск (Enter для пропуска фильтра)")
        
        print("Название: ", terminator: "")
        let titleInput = readLine()
        let title: String? = (titleInput?.isEmpty == false) ? titleInput : nil
        
        print("Автор: ", terminator: "")
        let authorInput = readLine()
        let author: String? = (authorInput?.isEmpty == false) ? authorInput : nil
        
        print("Жанр (1-fiction, 2-nonFiction, 3-mystery, 4-sciFi, 5-biography, 6-fantasy, Enter-пропустить): ", terminator: "")
        let genreInput = readLine()
        var genre: Genre? = nil
        if let g = genreInput, !g.isEmpty, let num = Int(g) {
            let genres = Genre.allCases
            if num >= 1 && num <= genres.count {
                genre = genres[num - 1]
            }
        }
        
        print("Тег: ", terminator: "")
        let tagInput = readLine()
        let tag: String? = (tagInput?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? tagInput?.trimmingCharacters(in: .whitespaces) : nil
        
        print("Год: ", terminator: "")
        let yearInput = readLine()
        let year: Int? = (yearInput?.isEmpty == false) ? Int(yearInput!) : nil
        
        let query = SearchQuery(title: title, author: author, genre: genre, tag: tag, year: year)
        let results = bookShelf.search(query)
        
        print("\nНайдено: \(results.count)")
        print(String(repeating: "─", count: 60))
        
        if results.isEmpty {
            print("Ничего не найдено\n")
        } else {
            for book in results {
                printBook(book)
            }
            print()
        }
    }
    
    private func printBook(_ book: Book) {
        print("\(book.title)")
        print("   Автор: \(book.author)")
        print("   Жанр: \(book.genre.rawValue)")
        if let year = book.publicationYear {
            print("   Год: \(year)")
        }
        if !book.tags.isEmpty {
            print("   Теги: \(book.tags.joined(separator: ", "))")
        }
        print("   ID: \(book.id)")
        print(String(repeating: "─", count: 60))
    }
}
