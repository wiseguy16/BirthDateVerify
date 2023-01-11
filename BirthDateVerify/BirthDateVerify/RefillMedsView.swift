//
//  RefillMedsView.swift
//  BirthDateVerify
//
//  Created by Gregory Weiss on 12/15/22.
//

import SwiftUI

struct RefillMedsView: View {
  let dateOnRecord: Date = mockAPIDateValue()
  @State private var showBirthDateAlert = false
  @State private var proceed = false
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Your Medications").font(.title)
        Divider()
        HStack {
          Text("Magic Pills")
          Image(systemName: "pills.fill")
          Spacer()
          Button(action: {
            showBirthDateAlert.toggle()
          }, label: {
            Text("Refil Now")
          }).buttonStyle(.borderedProminent)
        }
        Spacer()
        NavigationLink(
          destination: PaymentMedsView(),
          isActive: $proceed) { EmptyView() }
        Divider()
        VStack(alignment: .leading, spacing: 12) {
          Text("(Cheat Section)").bold()
          Text("For date of birth, pick October 31, 2022")
          Button(action: {
            proceed.toggle()
          }, label: {
            Text("Destination Preview >").foregroundColor(.black)
          })
        }
      }
      .padding()
      .background(
        AngularGradient(gradient: Gradient(colors: [.blue, .white, .pink]), center: .center)
      )
      .validatingBirthDate(dateOnRecord: dateOnRecord, isShowing: $showBirthDateAlert, proceedToNext: $proceed)
    }
  }
  
  static func mockAPIDateValue() -> Date {
    let dateOnRecordString = "2022-10-31"
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.dateFormat = "yyyy-MM-dd"
    return f.date(from: dateOnRecordString) ?? Date()
  }
}

struct RefillMedsView_Previews: PreviewProvider {
    static var previews: some View {
        RefillMedsView()
    }
}
