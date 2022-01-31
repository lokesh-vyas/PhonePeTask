//
//  Router.swift
//  APOD
//
//  Created by Lokesh Vyas on 28/01/22.
//

import Foundation


class ApodDataAccess {
    
    static func getAPods(date: String, onResponse: @escaping ([APOD]) -> Void){
        NetworkService.request(router: .getAPOD(date: date)) { (result: [APOD]) in
            onResponse(result)
        }
    }
    
    private static func getTenDaysBefore(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        let tenDaysFromDate = Calendar.current.date(byAdding: .day, value: -10, to: date ?? Date())
        
        return dateFormatter.string(from: tenDaysFromDate ?? Date())
    }
    
}
