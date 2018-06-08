import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(router: Router) throws {
        let categoryRoute = router.grouped("api","category")
        categoryRoute.get(use: getAllHandler)
        categoryRoute.get(Category.parameter, use: getHandler)
        categoryRoute.post(use: createHandler)
        categoryRoute.get(Category.parameter,"acronyms", use: getAcronymsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    func createHandler(_ req: Request) throws -> Future<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req)
    }
    
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(Category.self).flatMap(to: [Acronym].self) { category in
            return try category.acronyms.query(on: req).all()
        }
    }
    
}

extension Category: Parameter {}
