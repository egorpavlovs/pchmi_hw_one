Rails.application.routes.draw do
  root 'pages#question'
  get "/pages/:page" => "pages#show"
end
