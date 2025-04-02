class WeatherController < ApplicationController
    require 'httparty'
  
    def forecast
        url = "https://search.reservamos.mx/api/v2/places?q=#{params[:city_slug]}"
        cities = HTTParty.get(url)
      
        if cities.success?
            result = cities.map do |city|
                {
                id: city["id"],
                name: city["city_slug"],
                state: city["state"],
                latitude: city["lat"],
                longitude: city["long"],
                forecast: get_forecast(city["lat"], city["long"])
                }
            end
        render json: result
        else
        render json: { error: "Error" }, status: :bad_request
        end
    end

    private
    def get_forecast(lat, long)
        url = "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{long}&daily=temperature_2m_max,temperature_2m_min&forecast_days=7"
        forecast = HTTParty.get(url)
        
        if forecast.success?
            return [] unless forecast["daily"]
            return forecast["daily"]["time"].each_with_index.map do |dia, index|
                {
                  dia: dia,
                  temperatura_maxima: forecast["daily"]["temperature_2m_max"][index],
                  temperatura_minima: forecast["daily"]["temperature_2m_min"][index]
                }
              end
        else 
          return ""
        end 
    end
end