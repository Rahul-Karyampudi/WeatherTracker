import SwiftUI

struct ContentView: View {
    @State private var cityName: String = "" // User input
    @State private var weather: WeatherResponse? = nil // Weather data
    @State private var errorMessage: String? = nil // Error message
    private let weatherService = WeatherService() // Instance of WeatherService

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Weather Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Search Bar
            HStack {
                TextField("Enter city name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    fetchWeather()
                }) {
                    Text("Search")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }

            // Display Error Message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // Display Weather Information
            if let weather = weather {
                VStack(spacing: 10) {
                    Text("City: \(weather.location.name)")
                        .font(.title2)
                    Text("Temperature: \(weather.current.temp_c, specifier: "%.1f")°C")
                    Text("Condition: \(weather.current.condition.text)")
                    
                    // Display Weather Icon
                    if let iconURL = URL(string: "https:\(weather.current.condition.icon)") {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
            } else {
                Text("Enter a city name to get the weather")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            loadLastSearchedCity()
        }
    }

    // Fetch Weather Function
    private func fetchWeather() {
        weatherService.fetchWeather(for: cityName) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error
                    self.weather = nil
                } else {
                    self.weather = result
                    self.errorMessage = nil
                    saveLastSearchedCity()
                }
            }
        }
    }

    // Save Last Searched City to UserDefaults
    private func saveLastSearchedCity() {
        UserDefaults.standard.set(cityName, forKey: "LastSearchedCity")
    }

    // Load Last Searched City from UserDefaults
    private func loadLastSearchedCity() {
        if let savedCity = UserDefaults.standard.string(forKey: "LastSearchedCity") {
            self.cityName = savedCity
            fetchWeather()
        }
    }
}

#Preview {
    ContentView()
}
