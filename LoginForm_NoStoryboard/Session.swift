class Session {
    static let shared = Session()

    var token: String = ""
    var userId: Int = 0

    private init() {}
}
