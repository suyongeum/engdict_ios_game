struct Contents: Codable {
  var contents: [Content]
}

struct Content: Codable {
  var id: Int
  var name: String
}
