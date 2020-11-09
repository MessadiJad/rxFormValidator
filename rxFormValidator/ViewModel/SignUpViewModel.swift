import Foundation
import RxSwift
import RxCocoa
import Action

class SignUpViewModel {
    
    let nameSubject = BehaviorRelay<String?>(value: nil)
    let emailSubject = BehaviorRelay<String?>(value: nil)
    let passwordSubject = BehaviorRelay<String?>(value: nil)
    let submitButtonEnabled = BehaviorRelay(value: false)
    
    let formLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    
    private let disposeBag = DisposeBag()
    
    lazy var submitAction: Action<Void, SignUpModel> = {
        return Action(enabledIf: self.submitButtonEnabled.asObservable()) {
            self.formLoadingSubject.accept(true)
            return self.getFormData()
        }
    }()
    
    private func getFormData() -> Observable<SignUpModel> {
        let username = self.nameSubject.value ?? ""
        let email = self.emailSubject.value ?? ""
        let pass = self.passwordSubject.value ?? ""
        let fromData = SignUpModel.init(username: username, email: email, password: pass)
        return .just(fromData)
    }
    
    init() {
        Observable.combineLatest(nameSubject, emailSubject, passwordSubject) { (name, email, password) -> Bool in
            return (!password.isNilOrEmpty ? password!.isValidPassword() : false) &&
                !name.isNilOrEmpty &&
                (!email.isNilOrEmpty ? email!.isValidEmail() : false)
        } ~> submitButtonEnabled => disposeBag
    }
}


