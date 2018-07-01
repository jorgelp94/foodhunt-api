
import Vapor
import FluentSQLite

final class Restaurant: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Restaurant: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    
    public static var idKey: IDKey = \Restaurant.id
}
extension Restaurant: Migration {}
extension Restaurant: Content {}
