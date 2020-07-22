//
//  ImageDownloader.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

enum ImageDownloaderError: Error {
    case missingURL
    case missingData
    case corruptedData
}

final class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    @discardableResult
    func requestImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)  -> URLSessionDataTask? {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                let error = error ?? ImageDownloaderError.missingData
                DispatchQueue.main.async() {
                    completion(.failure(error))
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async() {
                    completion(.failure(ImageDownloaderError.corruptedData))
                }
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(image))
            }
        }
        
        task.resume()
        return task
    }
}
