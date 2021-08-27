//
//  ContentView.swift
//  MengWatch Extension
//
//  Created by Hannatassja Hardjadinata on 27/08/21.
//

import SwiftUI

struct ContentView: View {
    let upcomings: [Upcoming] =
        [ Upcoming(date: Date(), name: "Kaspar", detail: "Monthly Checkup"),
          Upcoming(date: Date(), name: "beh", detail: "meh")
        ]
    
    init() {
         
     }
    
    var body: some View {
        
        List {
            ForEach(0..<2) { i in
                UpcomingRow(upcoming: upcomings[i])
                    .listRowBackground(Color(#colorLiteral(red: 0.1058823529, green: 0.2669999897, blue: 0.3149999976, alpha: 1))
                    .clipped()
                    .cornerRadius(10))
            }
        }
        .padding(.top, 10)
        .padding([.leading, .trailing], 3)
        .navigationBarTitle("Upcoming")
        .listStyle(CarouselListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
