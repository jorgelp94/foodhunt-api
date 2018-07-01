import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.post("api", "restaurants") { req -> Future<Restaurant> in
        return try req.content.decode(Restaurant.self).flatMap(to: Restaurant.self) { restaurant in
            return restaurant.save(on: req)
        }
    }
    
    router.get("api", "restaurants") { req -> Future<[Restaurant]> in
        return Restaurant.query(on: req).all()
    }
    
    router.get("api", "restaurants", Restaurant.parameter) { req -> Future<Restaurant> in
        return try req.parameters.next(Restaurant.self)
    }
    
    router.put("api", "restaurants", Restaurant.parameter) { req -> Future<Restaurant> in
        return try flatMap(to: Restaurant.self, req.parameters.next(Restaurant.self), req.content.decode(Restaurant.self), { (restaurant, updatedRestaurant) in
            restaurant.name = updatedRestaurant.name
            return restaurant.save(on: req)
        })
    }
    
    router.delete("api", "restaurants", Restaurant.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Restaurant.self).delete(on: req).transform(to: HTTPStatus.noContent)
    }
    
    router.get("api", "restaurants", "search") { req -> Future<[Restaurant]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Restaurant.query(on: req).filter(\.name == searchTerm).all()
    }
}
