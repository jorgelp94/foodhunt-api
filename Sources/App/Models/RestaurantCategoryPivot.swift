
import Vapor
import FluentPostgreSQL
import Foundation

final class RestaurantCategoryPivot: PostgreSQLUUIDPivot {
    var id: UUID?
    var restaurantID: Restaurant.ID
    var categoryID: Category.ID
    
    typealias Left = Restaurant
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \.restaurantID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ restaurantID: Restaurant.ID, _ categoryID: Category.ID) {
        self.restaurantID = restaurantID
        self.categoryID = categoryID
    }
}

extension RestaurantCategoryPivot: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection, closure: { (builder) in
            try addProperties(to: builder)
            try builder.addReference(from: \.restaurantID, to: \Restaurant.id)
            try builder.addReference(from: \.categoryID, to: \Category.id)
        })
    }
}

