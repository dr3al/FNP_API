Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace 'api' do
    post "/dovers/search/notarius", to: "dovers#searchByNotarius"
    post "/dovers/search/consul", to: "dovers#searchByConsul"
    post "/dovers/search/official", to: "dovers#searchByOfficial"
    get "/dovers/captcha", to: "dovers#getCaptcha"
    get "/dovers/countries", to: "dovers#getCountries"
    get "/dovers/regions", to: "dovers#getRegions"
    get "/dovers/notarys", to: "dovers#getNotarys"

    post "/probates/search", to: "probates#search"
    get "/probates/wanted", to: "probates#wanted"
  end
end
