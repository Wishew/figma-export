// ABOUTME: FigmaClient is the main API client for Figma REST API
// ABOUTME: Supports automatic retry with exponential backoff for rate limiting

import Foundation
#if os(Linux)
import FoundationNetworking
#endif

final public class FigmaClient: BaseClient {

    private let baseURL = URL(string: "https://api.figma.com/v1/")!
    private let retryConfiguration: RetryConfiguration

    public init(
        accessToken: String,
        timeout: TimeInterval?,
        retryConfiguration: RetryConfiguration = .default
    ) {
        self.retryConfiguration = retryConfiguration
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = ["X-Figma-Token": accessToken]
        config.timeoutIntervalForRequest = timeout ?? 30
        super.init(baseURL: baseURL, config: config)
    }

    /// Convenience method that uses the client's default retry configuration
    public func requestWithRetry<T>(_ endpoint: T) throws -> T.Content where T: Endpoint {
        return try requestWithRetry(endpoint, configuration: retryConfiguration)
    }

}
