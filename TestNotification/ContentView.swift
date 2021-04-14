//
//  ContentView.swift
//  TestNotification
//
//  Created by Xiaohe Dong on 4/13/21.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    var body: some View {
        print("started \n")
        registerForPushNotifications()
        return Text("Hello, world! 123")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        print("started \n")
        return ContentView()
    }
}
