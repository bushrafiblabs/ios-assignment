
import UIKit

struct User {
  var name: String
  var image: String
  var items: [String]
  init(_ dictionary: [String: Any]) {
    self.name = dictionary["name"] as? String ?? ""
    self.image = dictionary["image"] as? String ?? ""
    self.items = dictionary["items"] as? [String] ?? []
  }
}
