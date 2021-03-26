//
//  ShiftHistoryResponse.swift
//  shiftman
//
//  Created by Stefan OShea on 26/3/21.
//

import Foundation
import UIKit

struct ShiftHistoryModel {
    let id: Int
    let image: UIImage
    let startTime: String
    let endTime: String
    let startDate: String
}

struct ShiftHistoryResponse: Decodable {
    let id: Int
    let start: String
    let end: String
    let startLatitude: String
    let startLongitude: String
    let endLatitude: String
    let endLongitude: String
    let image: String
    
    func mapToDomain() -> ShiftHistoryModel? {
        guard let url = URL(string: image),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return ShiftHistoryModel(id: id,
                                 image: image,
                                 startTime: mapTime(start),
                                 endTime: mapTime(end), startDate: mapDay(start))
    }
    
    private func mapTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZ"
        
        guard let date = formatter.date(from: time) else { return "" }
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func mapDay(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZ"
        
        guard let date = formatter.date(from: string) else { return "" }
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}
