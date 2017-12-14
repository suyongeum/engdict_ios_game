import Alamofire
import ReactiveSwift

class AppServerClient {
	public static let shared = AppServerClient()
	private init() {}
	
	// MARK: - Error types
	enum ServerError: Int, Error {
		case unnamedError = 1
	}
	
	func getSentence() -> SignalProducer<Words, ServerError> {
		return SignalProducer { observer, disposable in
			let parameters: Parameters = [UrlParameters.contentId: GameConfig.contentId, UrlParameters.lineId: GameConfig.lineId, UrlParameters.difficulty: GameConfig.difficulty]
			Alamofire.request(Network.apiUrl + Network.sentenceMethod, method: .get, parameters: parameters, encoding: URLEncoding.default)
				.validate(statusCode: [200])
				.responseJSON { response in
				guard response.error == nil else {
					if let statusCode = response.response?.statusCode, let error = ServerError(rawValue: statusCode) {
						observer.send(error: error)
					} else {
						observer.send(error: ServerError.unnamedError)
					}
					return
				}
				
				guard let data = response.data else { return }
				let decoder = JSONDecoder()
				
				do {
					let words = try decoder.decode(Words.self, from: data)
					observer.send(value: words)
					observer.sendCompleted()
				} catch {
					observer.send(error: ServerError.unnamedError)
				}
			}
		}
	}
}
