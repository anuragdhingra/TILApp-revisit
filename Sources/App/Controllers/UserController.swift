import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRoute = router.grouped("api","users")
        userRoute.get(use: getAllHandler)
        userRoute.get(User.parameter, use: getHandler)
        userRoute.post(use: createHandler)
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
    
}

extension User: Parameter {}
