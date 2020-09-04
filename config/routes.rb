Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'payments#index'

  get "/payments", :to => 'payments#get_payment_methods'
  post 'api/initiatePayment', :to => 'payments#initiate_payment'
  get  'api/handleRedirect', :to => 'payments#handle_redirect'
  post 'api/handleRedirect', :to => 'payments#handle_redirect'
  post 'api/submitAdditionalDetails', :to => 'payments#submit_additional_details'

  get "success", :to => 'payments#success'
  get "failed", :to => 'payments#failed'
  get "error", :to => 'payments#error'
  get "pending", :to => 'payments#pending'
  get "/pay", :to => 'payments#get_payment_methods'
end

