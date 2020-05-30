//
//  ContentView.swift
//  Windworks
//
//  Created by Dave Boyce on 5/30/20.
//  Copyright © 2020 Dave Boyce. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("Classes")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Classes")
                    }
                }
                .tag(0)
            Text("Charters")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Charters")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
