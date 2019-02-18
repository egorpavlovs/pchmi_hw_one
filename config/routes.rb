Rails.application.routes.draw do
  root 'pages#question'
  get "/pages/:page" => "pages#show"
  put "complete_answers", to: "pages#complete", as: :complete_answers
end
