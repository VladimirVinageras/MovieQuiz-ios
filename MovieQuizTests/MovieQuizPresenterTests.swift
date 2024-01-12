//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Vladimir Vinakheras on 12.01.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quizStepViewModel: MovieQuiz.QuizStepViewModel) {
    }
    
    func showQuizResults(quizResultsViewModel: MovieQuiz.QuizResultsViewModel) {
    }
    
    func handleEnableAnswersButtons() {
    }
    
    func configureImageFrame(color: CGColor) {
    }
    
    func showNetworkError(message: String) {
    }
    
    func hideLoadingIndicator() {
    }
    
    func showLoadingIndicator() {
    }
}


final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let movieQuizPresenter = MovieQuizPresenter(viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = movieQuizPresenter.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
