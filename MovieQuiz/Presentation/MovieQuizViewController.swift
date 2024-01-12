import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    
//MARK: - Delegate variables
    private var alertPresenter : AlertPresenterProtocol?
    
//MARK: - Presenter Variable
    
    private var movieQuizPresenter : MovieQuizPresenter!
    
//MARK: - App variables
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var noAnswerButton: UIButton!
    @IBOutlet weak var yesAnswerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
// MARK: - System "must be" fucntions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieQuizPresenter = MovieQuizPresenter(self)
        alertPresenter = AlertPresenter(delegate: self)
        
        showLoadingIndicator()
        
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
    //MARK: - MovieQuizViewControllerProtocol
    
    func show(quizStepViewModel: QuizStepViewModel) {
        previewImageView.image = quizStepViewModel.image
        questionLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
    }
    
    func showQuizResults(quizResultsViewModel: QuizResultsViewModel){
        let alertIdentifier = "Game results"
        let alertModel = AlertModel(title: quizResultsViewModel.title,
                                    text: quizResultsViewModel.text,
                                    buttonText: quizResultsViewModel.buttonText,
                                    identifier: alertIdentifier,
                                    completion: { [weak self] in
            self?.movieQuizPresenter.restartGame()
        })
        
        alertPresenter?.showAlert(alertModel: alertModel)
    }
    
    func handleEnableAnswersButtons(){
        noAnswerButton.isEnabled.toggle()
        yesAnswerButton.isEnabled.toggle()
    }
    
    func configureImageFrame(color: CGColor) {
        UIView.animate(withDuration: 0.68) { [weak self] in
            self?.previewImageView.layer.masksToBounds = true
            self?.previewImageView.layer.borderWidth = 8
            self?.previewImageView.layer.cornerRadius = 20
            self?.previewImageView.layer.borderColor = color
        }
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Ошибка",text: message,buttonText: "Попробовать еще раз", identifier: "Network Error") {
            [weak self] in
            guard let self = self else { return }
            
            movieQuizPresenter.restartingQuestionFactory()
            movieQuizPresenter.restartGame()
            showLoadingIndicator()
        }
        alertPresenter?.showAlert(alertModel: alertModel )
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

//MARK: - Storyboard Actions
    
    @IBAction private func yesButtonTapped(_ sender: Any) {
        movieQuizPresenter.yesButtonTapped()
    }
    @IBAction private func noButtonTapped(_ sender: Any) {
        movieQuizPresenter.noButtonTapped()
    }
}

//MARK: - AlertPresenterDelegate
extension MovieQuizViewController : AlertPresenterDelegate {
    func willShowAlert(alert: UIViewController) {
        self.present(alert, animated: true){
        }
    }
}

