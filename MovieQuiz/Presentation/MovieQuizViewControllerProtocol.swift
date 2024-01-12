//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Vladimir Vinakheras on 12.01.2024.
//

import Foundation
import CoreGraphics


protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quizStepViewModel: QuizStepViewModel)
    func showQuizResults(quizResultsViewModel: QuizResultsViewModel)
    func handleEnableAnswersButtons()
    func configureImageFrame(color: CGColor)
    func showNetworkError(message: String)
    func hideLoadingIndicator()
    func showLoadingIndicator()
}
