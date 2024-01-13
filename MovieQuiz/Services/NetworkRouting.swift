//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Vladimir Vinakheras on 10.01.2024.
//

import Foundation


protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
