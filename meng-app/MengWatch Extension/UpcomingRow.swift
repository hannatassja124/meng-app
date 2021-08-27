//
//  UpcomingRow.swift
//  MengWatch Extension
//
//  Created by Hannatassja Hardjadinata on 27/08/21.
//

import SwiftUI

struct UpcomingRow: View {
    var upcoming: Upcoming
    
    var body: some View {
        HStack {
            Text(upcoming.name)
        }
    }
}

struct UpcomingRow_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingRow(upcoming: upcomings[0])
    }
}
