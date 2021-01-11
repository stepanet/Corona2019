//
//  ContentView.swift
//  Corona2019
//
//  Created by Пятин Дмитрий on 10.01.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var infections:[CovidData] = []
    @State var infectionsBefore:[CovidData] = []
    @State var countrys:[CountryData] = []
    @State private var selectedCountry = 0
    @State var countryName = ""
    @State var disablePicker = 0
    @State var cases: Int  = 0
    
    var body: some View {
        
        VStack {
            
            Text("Covid-2019 information for Amir")
                .font(.largeTitle)
                .kerning(-2)
                .multilineTextAlignment(.center)
                
            Divider()
            Text("Country: \(self.countryName)")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            Text("Number of cases: \(infections.last?.Confirmed ?? 0)")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            Text("The gain for the day: \(cases)")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            Divider()
            
            NavigationView {
                Form {
                    Section {
                        Picker(selection: $selectedCountry, label: Text("")) {
                            ForEach(0 ..< countrys.count) {
                                Text(self.countrys[$0].Country)
                            }
                        }
                    }
                }
                .navigationBarTitle("Country choice")
            }
            .padding(.top, 30)
            .disabled((disablePicker != 0) ? true : false)
            .labelsHidden()
            .id(UUID())
            .onChange(of: selectedCountry, perform: { value in
                self.disablePicker = 1
                self.countryName = countrys[value].Country
                
                Api().getCoviData(country: countrys[value].Slug) { (infections) in
                    self.infections = infections
                    self.infectionsBefore = self.infections.suffix(2)
                    guard let casesNew = infections.last?.Confirmed else {
                        self.disablePicker = 0
                        self.cases = 0
                        return }
                    guard let casesOld = infectionsBefore.first?.Confirmed else {
                        self.disablePicker = 0
                        self.cases = 0
                        return }
                    self.cases = casesNew - casesOld
                    self.disablePicker = 0
                }
            })
            Spacer()
        }
        .onAppear() {
            ApiCountry().getCountryData() { (countrys) in
                self.countrys = countrys
                guard let index = self.countrys.firstIndex(where: { $0.Country == "Russian Federation" }) else { return }
                selectedCountry = index
                self.countryName = countrys[selectedCountry].Country
                
                Api().getCoviData(country: countrys[selectedCountry].Slug) { (infections) in
                    self.infections = infections
                    self.infectionsBefore = self.infections.suffix(2)
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
