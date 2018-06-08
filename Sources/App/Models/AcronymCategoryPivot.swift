import Vapor
import FluentSQLite

final class AcronymCategoryPivot : SQLitePivot {
    var id: Int?
    var acronymID: Acronym.ID
    var categoryID: Category.ID
    
    typealias Left = Acronym
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \.acronymID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(acronymID : Acronym.ID, categoryID : Category.ID) {
        self.acronymID = acronymID
        self.categoryID = categoryID
    }
}

extension AcronymCategoryPivot : Migration{}

