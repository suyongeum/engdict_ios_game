//
//  Configuration.swift
//  Eumgame
//
//  Created by Elena Kapilevich on 10/28/17.
//  Copyright © 2017 KinakoInc. All rights reserved.
//
import Foundation
import ReactiveSwift

struct Sentence {
	var sentence: MutableProperty<String>
	var userWord: MutableProperty<String>
	var soundUrl: MutableProperty<String>
}

class Configuration: NSObject {
	public static let shared = Configuration()
	var sentence: MutableProperty<Sentence>

	override private init() {
		sentence = MutableProperty(Sentence.init(sentence: MutableProperty(""), userWord: MutableProperty(""), soundUrl: MutableProperty("")))
		super.init()
	}
}