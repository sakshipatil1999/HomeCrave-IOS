//
//  RegisterHomeCookView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI


struct RegisterHomeCookView: View {
    
    // Declare state variables for capturing user input
    @State private var OwnerName = ""
    @State private var RName = ""
    @State private var RTiming = Date()
    @State private var OwnerEmail = ""
    @State private var OwnerPhoneNumber = ""
    @State private var OwnerPassword = ""
    
    // Declare state variables for showing/hiding time picker
    @State private var showOpenTimePicker = false
    @State private var showCloseTimePicker = false
    @State private var openTime = Date()
    @State private var closeTime = Date()
    
    // Create an instance of the view model
    var registerViewModel = RegisterRestaurantViewModel()
    
    // Declare bindings for showing the sign-in view and determining if the user is a home cook
    @Binding var showSignInView: Bool
    @Binding var isHomeCook: Bool
    
    // Create the view hierarchy
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Show the title of the view
                    Text("Input Your Restaurant's Details")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 15)
                        .multilineTextAlignment(.center)
                    
                    // Text field for capturing owner's name
                    TextField("Owner's Name", text: $OwnerName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Text field for capturing restaurant's name
                    TextField("Restaurant's Name", text: $RName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Text field for capturing owner's phone number
                    TextField("Phone Number", text: $OwnerPhoneNumber)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Text field for capturing owner's email
                    TextField("Email", text: $OwnerEmail)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    
                    // Secure text field for capturing owner's password
                    SecureField("Password", text: $OwnerPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    // Button for showing the time picker for the restaurant's opening time
                    HStack {
                        Button(action: {
                            showOpenTimePicker = true
                        }) {
                            Text("Select Open Time")
                        }
                        Text(openTime, formatter: timeFormatter)
                            .padding()
                    }
                    
                    // Button for showing the time picker for the restaurant's closing time
                    HStack {
                        Button(action: {
                            showCloseTimePicker = true
                        }) {
                            Text("Select Close Time")
                        }
                        Text(closeTime, formatter: timeFormatter)
                            .padding()
                    }
                    Button(action: {
                        // Perform registration process when the button is pressed
                        Task{
                            do{
                                // Call the registerRestaurant() method of the registerViewModel with the required parameters
                                try await registerViewModel.registerRestaurant(ownerName: OwnerName, restaurantName: RName, ownerEmail: OwnerEmail, ownerPhoneNumber: OwnerPhoneNumber, ownerPassword: OwnerPassword, openTime: openTime, closeTime: closeTime)
                                // If the registration process is successful, set isHomeCook to true and hide the registration view
                                isHomeCook = true
                                showSignInView = false
                            }
                            catch{
                                // If there is an error during the registration process, print the error
                                print(error)
                            }
                        }
                        
                    }) {
                        // The register button
                        Text("Register Your Restaurant")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TitleTextColor"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.all)
                    }
                    
                    // The login link
                    NavigationLink(
                        destination: RLoginView(showSignInView: $showSignInView, isHomeCook: $isHomeCook).navigationBarHidden(true),
                        label: {
                            Text("Login Instead")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TitleTextColor"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("PrimaryColor"))
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding(.all)
                        })
                    
                    // Show the open and close time pickers in a sheet
                    .sheet(isPresented: $showOpenTimePicker) {
                        datePicker(for: "Open Time", selection: $openTime)
                    }
                    .sheet(isPresented: $showCloseTimePicker) {
                        datePicker(for: "Close Time", selection: $closeTime)
                    }
                }
            }
        }
    }
    
    // A helper method to create a date picker
    private func datePicker(for title: String, selection: Binding<Date>) -> some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()
            
            // The actual date picker component
            DatePicker("", selection: selection, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .padding()
            
            // A "Done" button to dismiss the picker
            Button(action: {
                if title == "Open Time" {
                    showOpenTimePicker = false
                } else if title == "Close Time" {
                    showCloseTimePicker = false
                }
            }) {
                Text("Done")
            }
            .padding()
        }
    }
    
    // A date formatter for displaying time in a readable format
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


struct RegisterHomeCookView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterHomeCookView(showSignInView: .constant(false), isHomeCook: .constant(false))
    }
}
