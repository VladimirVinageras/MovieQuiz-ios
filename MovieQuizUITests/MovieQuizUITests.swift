//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Vladimir Vinakheras on 10.01.2024.
//

import XCTest

@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
       
        app = XCUIApplication()
        app.launch()
       
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton(){
        sleep(3)
           
           let firstPoster = app.images["Poster"]
           let firstPosterData = firstPoster.screenshot().pngRepresentation
           
           app.buttons["Yes"].tap()
           sleep(3)
           
           let secondPoster = app.images["Poster"]
           let secondPosterData = secondPoster.screenshot().pngRepresentation
           
           XCTAssertNotEqual(firstPosterData, secondPosterData)
        
    }

}
