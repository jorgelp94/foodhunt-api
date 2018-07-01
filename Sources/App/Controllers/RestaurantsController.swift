
import Vapor
import Fluent

struct RestaurantsController: RouteCollection {
    func boot(router: Router) throws {
        let restaurantsRoutes = router.grouped("api", "restaurants")
        restaurantsRoutes.get(use: getAllHandler)
        restaurantsRoutes.post(Restaurant.self, use: createHandler)
        restaurantsRoutes.get(Restaurant.parameter, use: getHandler)
        restaurantsRoutes.put(Restaurant.parameter, use: updateHandler)
        restaurantsRoutes.delete(Restaurant.parameter, use: deleteHandler)
        restaurantsRoutes.get("search", use: searchHandler)
        restaurantsRoutes.get(Restaurant.parameter, "user", use: getUserHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Restaurant]> {
        return Restaurant.query(on: req).all()
    }
    
    func createHandler(_ req: Request, restaurant: Restaurant) throws -> Future<Restaurant> {
        return restaurant.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Restaurant> {
        return try req.parameters.next(Restaurant.self)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Restaurant> {
        return try flatMap(to: Restaurant.self, req.parameters.next(Restaurant.self), req.content.decode(Restaurant.self), { (restaurant, updatedRestaurant) in
            restaurant.name = updatedRestaurant.name
            restaurant.userID = updatedRestaurant.userID
            return restaurant.save(on: req)
        })
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Restaurant.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    func searchHandler(_ req: Request) throws -> Future<[Restaurant]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Restaurant.query(on: req).filter(\.name == searchTerm).all()
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Restaurant.self).flatMap(to: User.self) { restaurant in
            try restaurant.user.get(on: req)
        }
    }
}
