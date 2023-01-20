//
//  DataPersistenceManager.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 19.01.2023.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSave
    case failedToFetch
    case failedToDelete
}


class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
     
    func downloadTitle(with model: Title, completion: @escaping (Result<Void , Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.vote_count = Int64(model.vote_count)
        item.release_date = model.release_date
        item.vote_average = model.vote_average ?? Double(0.0)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print("Could not save, error: \(error.localizedDescription)")
            completion(.failure(DatabaseError.failedToSave))
        }
    }
    
    
    func fetchTitles(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        
        //let request: NSFetchRequest<TitleItem>
        
            //request = TitleItem.fetchRequest()
        let request = TitleItem.fetchRequest()
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetch ))
            print(error.localizedDescription)
        }
    }
    
    
    func deleteTitle(with model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
    
}
