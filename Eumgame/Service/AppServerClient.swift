//
//  AppServerClient.swift
//  Eumgame
//
//  Created by Elena Kapilevich on 10/28/17.
//  Copyright © 2017 KinakoInc. All rights reserved.
//

import Alamofire
import ReactiveSwift

class AppServerClient {
	//TODO: Temp counter for test. Remove after adding server side
	private var tempCounter: Int = 0
	public static let shared = AppServerClient()
	private init() {}
	
	// MARK: - Error types
	enum ServerError: Int, Error {
		case unnamedError = 1
	}
	
	func getSentence() -> SignalProducer<(sentence: String, userWord: String, soundUrl: String), ServerError> {
		return SignalProducer { observer, disposable in
			/*let parameters:Parameters = [:]
			Alamofire.request(Network.apiUrl + Network.sentenceMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
					
					if let result = response.result.value {
						let jsonResult = result as! Dictionary<String, Any>
						observer.send(value: (sentence: jsonResult[JsonKey.pairId] as! String,
												userWord: jsonResult[JsonKey.recipientName,
												soundUrl: jsonResult[JsonKey.recipientName] as! String))
						observer.sendCompleted()
					}
			}*/
			observer.send(value: (sentence: "Test0 Test\(self.tempCounter) Test2", userWord: "Test\(self.tempCounter)", soundUrl: ""))
			observer.sendCompleted()
			self.tempCounter += 1
		}
	}
}
