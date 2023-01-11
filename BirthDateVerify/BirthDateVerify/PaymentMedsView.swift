//
//  PaymentMedsView.swift
//  BirthDateVerify
//
//  Created by Gregory Weiss on 12/15/22.
//

import SwiftUI

struct PaymentMedsView: View {
  
  var body: some View {
    VStack {
      Text("Payment for Meds").font(.title)
      Divider()
      HStack {
        Text("Magic Pills")
        Image(systemName: "pills.fill")
        Spacer()
        Text("Quantity: 30")
      }
      Button(action: {}, label: {
        Text("Pay Now")
      }).buttonStyle(.borderedProminent)
      Spacer()
    }
    .padding()
    .background(
      AngularGradient(gradient: Gradient(colors: [.green, .blue, .white, .green]), center: .center)
    )
  }
  
}


struct PaymentMedsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMedsView()
    }
}
