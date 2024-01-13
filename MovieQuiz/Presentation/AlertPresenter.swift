//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir Vinageras on 14.12.2023.
//

import Foundation
import UIKit



class AlertPresenter: AlertPresenterProtocol{
    
    weak var delegate : AlertPresenterDelegate?
    
    private var alertModel : AlertModel?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func setDelegate(_ delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel : AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.text,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = alertModel.identifier
        let action = UIAlertAction(title: alertModel.buttonText, style: .default){ _ in
            alertModel.completion()
        }
        alert.addAction(action)
        
        delegate?.willShowAlert(alert: alert)
    }
}

