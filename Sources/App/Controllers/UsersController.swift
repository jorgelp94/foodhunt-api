
import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        usersRoutes.post(User.self, use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(User.parameter, use: getHandler)
        usersRoutes.get(User.parameter, "restaurants", use: getRestaurantsHandler)
    }
    
    func createHandler(_ req: Request, user: User) throws -> Future<User> {
        return user.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func getRestaurantsHandler(_ req: Request) throws -> Future<[Restaurant]> {
        return try req.parameters.next(User.self).flatMap(to: [Restaurant].self) { user in
            try user.restaurants.query(on: req).all()
        }
    }
}
