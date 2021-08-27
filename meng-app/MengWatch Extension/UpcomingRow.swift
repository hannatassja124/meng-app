//
//  UpcomingRow.swift
//  MengWatch Extension
//
//  Created by Hannatassja Hardjadinata on 27/08/21.
//

import SwiftUI

var upcomings =
    [ Upcoming(date: Date(), name: "Kaspar", detail: "Monthly Checkup"),
  Upcoming(date: Date(), name: "beh", detail: "meh")
]

struct UpcomingRow: View {
    var upcoming: Upcoming
    
    var body: some View {

        VStack {
            HStack {
                Text("June 27, 2020")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                Spacer()
                Text("10:00")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            .padding(.top, 14)
            
            VStack {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 8.0, height: 8.0)
                    Text(" ")
                    Text(upcoming.name)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                }.frame(width: 150
                        , alignment: .leading)
                Text(upcoming.detail)
                    .fontWeight(.semibold)
                    .padding(.leading, 22)
                    .frame(width: 150, alignment: .leading)
                    .font(.system(size: 14))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.7557213902, blue: 0.7119714618, alpha: 1)))
            }
            .padding(.bottom, 20.0)
            .padding(.top, 5)
        }
        .foregroundColor(Color(#colorLiteral(red: 0.9984837174, green: 0.9839375615, blue: 0.9796521068, alpha: 1)))
    } 
}

struct UpcomingRow_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingRow(upcoming: upcomings[0])
            .previewLayout(.fixed(width: 184.0, height: 110))
    }
}
