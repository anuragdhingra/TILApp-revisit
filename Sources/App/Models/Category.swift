import Vapor
import FluentSQLite


final class Category: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Category: Content {}
extension Category: Migration {}
extension Category: SQLiteModel {}

