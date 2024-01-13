//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir Vinakheras on 12.01.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    //MARK: - MovieQuizViewController Variable
    private weak var movieQuizViewController: MovieQuizViewControllerProtocol?
    
    
    //MARK: - Protocol type variables
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService : StatisticService?
           
    
    //MARK: - App variables
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var userAnswer = false
    
    init(_ movieQuizViewController: MovieQuizViewControllerProtocol) {
        self.movieQuizViewController = movieQuizViewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
     //   alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
    }
    
    
     func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    
    private func presentNextQuizStepQuestion(){
        UIView.animate(withDuration: 1){ [weak self] in
            self?.questionFactory?.requestNextQuestion()
            
        }
    }
    
     func createMessageToShowInAlert() -> String{
        let recordToShow = statisticService?.bestGame
        guard let gamesCount = statisticService?.gamesCount else {return "0"}
        guard let recordCorrectAnswers = recordToShow?.correctAnswers else {return "0"}
        guard let recordTotalQuestions = recordToShow?.totalQuestions else {return "0"}
        guard let accuracy = statisticService?.totalAccuracy else {return "0"}
        guard let date = recordToShow?.date.dateTimeString else {return Date().dateTimeString}
        
        let messageToShow = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количесвто сыгранных квизов: \(gamesCount)
        Рекорд: \(recordCorrectAnswers.description)/\(recordTotalQuestions) (\(date))
        Средняя точность: \(String(format: "%.2f",accuracy))%
        """
        
        return messageToShow
    }
    
  
    
    func proceedToNextQuestionOrResults() {
        self.currentQuestionIndex += 1
        if currentQuestionIndex >= (questionsAmount) {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let messageToShow = createMessageToShowInAlert()
            let quizResultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: messageToShow,
                buttonText: "Сыграть ещё раз")
            movieQuizViewController?.showQuizResults(quizResultsViewModel: quizResultViewModel)
        } else {
            presentNextQuizStepQuestion()
        }
    }
    
    private func proceedWithAnswerResult(isCorrect: Bool) {
        var color = UIColor(resource: .ypRed).cgColor  /// functions for this
        if isCorrect {
            correctAnswers += 1
            color = UIColor(resource: .ypGreen).cgColor
        }
        movieQuizViewController?.configureImageFrame(color: color)
        movieQuizViewController?.handleEnableAnswersButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            movieQuizViewController?.configureImageFrame(color: (UIColor(resource: .ypGray).withAlphaComponent(0)).cgColor)
            proceedToNextQuestionOrResults()
            movieQuizViewController?.handleEnableAnswersButtons()
        }
    }
    

    
    func restartingQuestionFactory(){
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory?.loadData()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}

//MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter : QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        movieQuizViewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        movieQuizViewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let quizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.movieQuizViewController?.show(quizStepViewModel: quizStepViewModel)
        }
    }
}


