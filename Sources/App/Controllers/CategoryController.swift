import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(router: Router) throws {
        let categoryRoute = router.grouped("api","category")
        categoryRoute.get(use: getAllHandler)
        categoryRoute.get(Category.parameter, use: getHandler)
        categoryRoute.post(use: createHandler)
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
    
}

extension Category: Parameter {}
