
import Vapor
import FluentPostgreSQL

final class Restaurant: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Restaurant: PostgreSQLModel {}
extension Restaurant: Migration {}
extension Restaurant: Content {}
extension Restaurant: Parameter {}
