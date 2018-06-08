import Vapor
import FluentMySQL

final class AcronymCategoryPivot : MySQLPivot {
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

