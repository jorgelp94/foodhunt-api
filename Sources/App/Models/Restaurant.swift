
import Vapor
import FluentPostgreSQL

final class Restaurant: Codable {
    var id: Int?
    var name: String
    var userID: User.ID
    
    init(name: String, user: User.ID) {
        self.name = name
        self.userID = user
    }
}

extension Restaurant: PostgreSQLModel {}
extension Restaurant: Content {}
extension Restaurant: Parameter {}

extension Restaurant {
    var user: Parent<Restaurant, User> {
        return parent(\.userID)
    }
    
    var categories: Siblings<Restaurant, Category, RestaurantCategoryPivot> {
        return siblings()
    }
}

extension Restaurant: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addReference(from: \.userID, to: \User.id)
        }
    }
}
