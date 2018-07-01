import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let restaurantsController = RestaurantsController()
    try router.register(collection: restaurantsController)
}
