import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    try configureDatabases(env, &services)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Acronym.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Category.self, database: .mysql)
    migrations.add(model: AcronymCategoryPivot.self, database: .mysql)
    services.register(migrations)
    
    /// Configure the rest of your application here
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}

// MARK: - Databases
private func configureDatabases(_ env: Environment, _ services: inout Services) throws {
    // MARK: - MySQL
    // Configure a MySQL database
    let mysqlConfig: MySQLDatabaseConfig
    
    // Wrap the following MySQL-related code in an if-else statement like this
    // once `vapor/mysql` gets support for initializing connection from a
    // connection string (PR `vapor/mysql#177`).
    //
    // if let url = Environment.get("DATABASE_URL") {
    //     mysqlConfig = try MySQLDatabaseConfig(url: url)
    // } else {
    //     … rest of the code
    // }
    let databaseName: String
    let databasePort: Int
    
    if env == .testing {
        databaseName = "vapor-test"
        
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 3307
        } else {
            databasePort = 3307
        }
    } else {
        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        databasePort = 3306
    }
    
    let databaseHostname = Environment.get("DATABASE_HOSTNAME") ?? "127.0.0.1"
    let databaseUsername = Environment.get("DATABASE_USERNAME") ?? "til"
    let databasePassword = Environment.get("DATABASE_PASSWORD") ?? "password"
    
    mysqlConfig = MySQLDatabaseConfig(
        hostname: databaseHostname,
        port: databasePort,
        username: databaseUsername,
        password: databasePassword,
        database: databaseName
    )
    
    let mysql = MySQLDatabase(config: mysqlConfig)
    
    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)
}

