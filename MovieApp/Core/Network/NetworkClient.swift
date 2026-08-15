//
//  NetworkClient.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

final class NetworkClient {

    static func request<T: Decodable>(
        _ endpoint: NetworkEndpoint
    ) async throws -> T {

        guard var components = URLComponents(
            string: endpoint.baseURL
        ) else {
            throw APIError.invalidURL
        }

        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.httpError(httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode(
                    T.self,
                    from: data
                )
            } catch {
                throw APIError.decodingError(error)
            }

        } catch let error as APIError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw CancellationError()
        } catch {
            throw APIError.networkError(error)
        }
    }
}
