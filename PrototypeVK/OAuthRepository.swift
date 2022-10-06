//
//  OAuthRepository.swift
//  PrototypeVK
//
//  Created by Alexey Kharin on 02.10.2022.
//
import SafariServices
import Foundation
import AppAuth

class OAuthRepository {

    private let configuration = OIDServiceConfiguration.init(
        authorizationEndpoint: URL(string: AuthConfiguration.baseUrl + AuthConfiguration.authUri)!,
        tokenEndpoint: URL(string: AuthConfiguration.baseUrl + AuthConfiguration.tokenUri)!,
        issuer: nil,
        registrationEndpoint: nil,
        endSessionEndpoint: URL(string: AuthConfiguration.baseUrl + AuthConfiguration.endSessionUri)!)
    
    func login(viewController: UIViewController) {
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: AuthConfiguration.clientId,
            clientSecret: AuthConfiguration.clientSecret,
            scopes: AuthConfiguration.scopes,
            redirectURL: URL(string: AuthConfiguration.callbackUrl)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil)
        
        let agent = OIDExternalUserAgentIOSSafariViewController(presentingViewController: viewController)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
//        appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: agent) { [weak self] authState, error in
//            if error == nil {
//                print(authState?.lastTokenResponse?.accessToken)
//                let tokenModel = TokenModel(access: authState?.lastTokenResponse?.accessToken,
//                                       refresh: authState?.lastTokenResponse?.refreshToken)
//                self?.userDefaultsHelper.setToken(value: tokenModel)
            }
        }
    
    


protocol OIDSafariViewControllerFactory {
    
    /*! @brief Creates and returns a new @c SFSafariViewController.
     @param URL The URL which the @c SFSafariViewController should load initially.
     */
    func safariViewControllerWithURL(url:URL) -> SFSafariViewController
}

/*! @brief A special-case iOS external user-agent that always uses
 \SFSafariViewController (on iOS 9+). Most applications should use
 the more generic @c OIDExternalUserAgentIOS to get the default
 AppAuth user-agent handling with the benefits of Single Sign-on (SSO)
 for all supported versions of iOS.
 */

class OIDDefaultSafariViewControllerFactory: NSObject, OIDSafariViewControllerFactory {
    func safariViewControllerWithURL(url: URL) -> SFSafariViewController {
        return SFSafariViewController.init(url: url)
    }
}

var gSafariViewControllerFactory:OIDSafariViewControllerFactory?

class OIDExternalUserAgentIOSSafariViewController:NSObject
{
    var _presentingViewController:UIViewController = UIViewController.init()
    var _externalUserAgentFlowInProgress:Bool = false
    weak var _session:OIDExternalUserAgentSession?
    weak var _safariVC:SFSafariViewController?
    
    
    /** @brief Obtains the current @c OIDSafariViewControllerFactory; creating a new default instance if
     required.
     */
    class func safariViewControllerFactory() -> OIDSafariViewControllerFactory
    {
        if let safariViewControllerFactory = gSafariViewControllerFactory
        {
            return safariViewControllerFactory
        }
        gSafariViewControllerFactory = OIDDefaultSafariViewControllerFactory.init()
        
        print("Forcing optional to unwrap, shouldn't fail :)")
        return gSafariViewControllerFactory!
    }
    
    
    /*! @brief Allows library consumers to change the @c OIDSafariViewControllerFactory used to create
     new instances of @c SFSafariViewController.
     @remarks Useful for customizing tint colors and presentation styles.
     @param factory The @c OIDSafariViewControllerFactory to use for creating new instances of
     @c SFSafariViewController.
     */
    class func setSafariViewControllerFactory(factory:OIDSafariViewControllerFactory)
    {
        gSafariViewControllerFactory = factory
    }
    
    
    
    /*! @internal
     @brief Unavailable. Please use @c initWithPresentingViewController:
     */
    @available(*, unavailable, message: "Please use @c initWithPresentingViewController")
    override init() {
        fatalError("Unavailable. Please use initWithPresentingViewController")
    }
    
    
    
    /*! @brief The designated initializer.
     @param presentingViewController The view controller from which to present the
     \SFSafariViewController.
     */
    required init(presentingViewController:UIViewController) {
        super.init()
        self._presentingViewController = presentingViewController
    }
    
    
    func cleanUp()
    {
        _safariVC = nil
        _session = nil
        _externalUserAgentFlowInProgress = false
    }
    
}


// MARK -: OIDExternalUserAgent
extension OIDExternalUserAgentIOSSafariViewController: OIDExternalUserAgent
{
    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool
    {
        if _externalUserAgentFlowInProgress
        {
            return false
        }
        
        _externalUserAgentFlowInProgress = true
        _session = session
        
        var openedSafari:Bool = false
        let requestURL = request.externalUserAgentRequestURL()
        
        if #available(iOS 9.0, *) {
            let Y = OIDExternalUserAgentIOSSafariViewController.self
            let safariVC = Y.safariViewControllerFactory().safariViewControllerWithURL(url: requestURL!)
            safariVC.delegate = self
            _safariVC = safariVC
            _presentingViewController.present(safariVC, animated: true, completion: nil)
            openedSafari = true
        }
        else {
            openedSafari = UIApplication.shared.canOpenURL(requestURL!)
        }
        
        if !openedSafari
        {
            self.cleanUp()
            let error = OIDErrorUtilities.error(with: .safariOpenError, underlyingError: nil, description: "Unable to open Safari.")
            session.failExternalUserAgentFlowWithError(error)
        }
        
        return openedSafari
    }
    
    
    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        if !_externalUserAgentFlowInProgress {
            // Ignore this call if there is no authorization flow in progress.
            return
        }
        
        guard let safariVC:SFSafariViewController = _safariVC else {
            completion()
            self.cleanUp()
            return
        }
        
        self.cleanUp()
        
        if #available(iOS 9.0, *) {
            safariVC.dismiss(animated: true, completion: completion)
        }
        else{
            completion()
        }
    }
}

// MARK -: SFSafariViewControllerDelegate
extension OIDExternalUserAgentIOSSafariViewController: SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if controller != _safariVC {
            // Ignore this call if the safari view controller do not match.
            return
        }
        
        if !_externalUserAgentFlowInProgress {
            // Ignore this call if there is no authorization flow in progress.
            return
        }
        
        guard let session = _session else { return }
        self.cleanUp()
        let error = OIDErrorUtilities.error(with: .programCanceledAuthorizationFlow, underlyingError: nil, description: nil)
        session.failExternalUserAgentFlowWithError(error)
    }
}
