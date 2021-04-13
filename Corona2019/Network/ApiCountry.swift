//
//  ApiCountry.swift
//  Corona2019
//
//  Created by Пятин Дмитрий on 11.01.2021.
//

import SwiftUI

class ApiCountry: ObservableObject {
    
    @Published var countrys = [CountryData]()
    
    func getCountryData(completion: @escaping([CountryData]) -> ()) {
        guard let url = URL(string: "https://api.covid19api.com/countries") else { return }
        URLSession.shared.dataTask(with: url) {(data, resp, err ) in
            guard let data = data else { return }
            DispatchQueue.main.async {
            
            do {
                self.countrys = try
                    JSONDecoder().decode([CountryData].self, from: data)
            } catch {
                print("Failed to json decode!:",error.localizedDescription)
            }
                completion(self.countrys.sorted {
                    $0.Country < $1.Country
                })
            }
        }.resume()
    }
}
