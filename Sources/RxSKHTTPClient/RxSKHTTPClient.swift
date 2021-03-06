
import SKHTTPClient
import RxSwift
import Foundation

public extension HTTPClient {
    
    func urlDataTask<T: Codable, GenError: Codable>(with request: URLRequest?, errorType: GenError.Type) -> Observable<T> {
        return Observable.create { [weak self] observer in
            let dataTask = self?.getURLDataTask(with: request, completion: { (response: T?, error: HTTPClientError<GenError>?) in
                if let response = response {
                    observer.on(.next(response))
                    observer.on(.completed)
                } else {
                    let defaultError = HTTPClientError<String>(type: .FAILED)
                    observer.on(.error(error ?? defaultError))
                }
            })
            
            if let dataTask = dataTask {
                dataTask.resume()
            } else {
                let error = HTTPClientError<String>(type: .invalidRequest)
                observer.on(.error(error))
            }
            
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}
