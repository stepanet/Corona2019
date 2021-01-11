//
//  CovidDataModel.swift
//  Corona2019
//
//  Created by Пятин Дмитрий on 11.01.2021.
//

import Foundation

struct CovidData: Codable {
    var Country,CountryCode : String
    var Confirmed: Int
}

