import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRoute = router.grouped("api","users")
        userRoute.get(use: getAllHandler)
        userRoute.get(User.parameter, use: getHandler)
        userRoute.post(use: createHandler)
        userRoute.get(User.parameter,"acronyms",use: getAcronymsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req)
    }
    
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(User.self).flatMap(to: [Acronym].self) { user in
            return try user.acronyms.query(on: req).all()
        }
    }
    
}

extension User: Parameter {}
