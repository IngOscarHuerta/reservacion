Rails.application.routes.draw do
  get 'weather', to: 'weather#forecast'
end
