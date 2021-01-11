//
//  Api.swift
//  Corona2019
//
//  Created by Пятин Дмитрий on 11.01.2021.
//

import SwiftUI

import SwiftUI

class Api: ObservableObject {
    
    @Published var infections = [CovidData]()
    
    func getCoviData(country: String, completion: @escaping([CovidData]) -> ()) {
        guard let url = URL(string: "https://api.covid19api.com/total/dayone/country/\(country.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) {(data, resp, err ) in
            guard let data = data else { return }
            do {
                self.infections = try
                    JSONDecoder().decode([CovidData].self, from: data)
            } catch {
                print("Failed to json decode:",error.localizedDescription)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                completion(self.infections)
            }
        }.resume()
    }
}
