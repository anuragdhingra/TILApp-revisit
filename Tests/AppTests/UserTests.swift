@testable import App
import Vapor
import XCTest
import FluentMySQL

final class UserTests: XCTestCase {
    func testUsersCanBeRetrievedFromAPI() throws {
        // 1
        let expectedName = "Alice"
        let expectedUsername = "alice"
        // 2
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        try App.configure(&config, &env, &services)
        let app = try Application(
            config: config,
            environment: env,
            services: services)
        try App.boot(app)
        // 3
        let conn = try app.newConnection(to: .mysql).wait()
        // 4
        let user = User(
            name: expectedName,
            username: expectedUsername)
        let savedUser = try user.save(on: conn).wait()
        _ = try User(
            name: "Luke",
            username: "lukes").save(on: conn).wait()
        // 5
        let responder = try app.make(Responder.self)
        // 6
        let request = HTTPRequest(
            method: .GET,
            url: URL(string: "/api/users")!)
        let wrappedRequest = Request(http: request, using: app)
        // 7
        let response = try responder
            .respond(to: wrappedRequest)
            .wait()
        // 8
        let data = response.http.body.data
        let users = try JSONDecoder().decode([User].self, from: data!)
        // 9
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[1].name, expectedName)
        XCTAssertEqual(users[1].username, expectedUsername)
        XCTAssertEqual(users[1].id, savedUser.id)
        
        // 10
        conn.close()
    }
    
}
