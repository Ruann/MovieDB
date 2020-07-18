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

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    func getImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            DispatchQueue.main.async() {
                completion(.failure(ImageDownloaderError.missingURL))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                let error = error ?? ImageDownloaderError.missingData
                DispatchQueue.main.async() {
                    completion(.failure(error))
                }
                return
            }

            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else {
                    completion(.failure(ImageDownloaderError.corruptedData))
                    return
                }
                
                completion(.success(image))
            }
        }
        
        task.resume()
    }
}
