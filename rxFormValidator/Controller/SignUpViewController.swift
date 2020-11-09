import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var mailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let rxbag = DisposeBag()
    private let signupViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "rxFormValidator"
        setFormViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func setFormViewModel() {
        
        signupViewModel.nameSubject <~> nameTextField.rx.text => rxbag
        signupViewModel.emailSubject <~> mailTextField.rx.text => rxbag
        signupViewModel.passwordSubject <~> passwordTextField.rx.text => rxbag
        signupViewModel.submitButtonEnabled ~> submitButton.rx.valid => rxbag
        submitButton.rx.bind(to: signupViewModel.submitAction, input: ())
        signupViewModel.submitAction.executionObservables.switchLatest()
            .subscribe(onNext: { formData in
                print(formData)
            }) => rxbag
        
        signupViewModel.formLoadingSubject.skip(1)
            .subscribe(onNext: { [weak self] (isLoading) in
                guard let self = self else {return}
                self.view.endEditing(true)
                let alert = UIAlertController(title: "rxFormValidator", message: "Form valid", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Thank you", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }) => self.rxbag
    }
}
