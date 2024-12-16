import Foundation

// Weather Data Models
struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String // City name
}

struct CurrentWeather: Codable {
    let temp_c: Double // Temperature in Celsius
    let condition: Condition
}

struct Condition: Codable {
    let text: String // Weather condition
    let icon: String // Weather icon URL
}

class WeatherService {
    private let apiKey = "2440f9cd289f438786c44355241612" // Your API Key

    // Fetch Weather Data Function
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?, String?) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    completion(weatherResponse, nil)
                } catch {
                    completion(nil, "City not found. Please try again.")
                }
            }
        }.resume()
    }
}
