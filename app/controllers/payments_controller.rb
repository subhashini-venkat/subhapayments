require 'json'

require 'adyen-ruby-api-library'

class PaymentsController < ApplicationController
    def index
    end


    def get_payment_methods
    #initializing adyen checkouts API library  
    #Making payment_methods call to Adyen's checkout API
        fullresponse = adyen.checkout.payment_methods({
          :merchantAccount => "SupportRecruitementCOM",
          :channel => 'Web',
          :countryCode => 'DE',
          :amount => {
            :currency => 'EUR',
            :value => 1000
          }
        })
        @dropin = fullresponse.response.to_json
        #Displaying the payments_response on terminal
        puts JSON.pretty_generate(@dropin)
        render 'pay'
    end


    def initiate_payment
        # Making /payments call when Pay button is clicked.
        paymentMethod = params["paymentMethod"]
        payment_response = make_payment(paymentMethod).response
        result_code = payment_response["resultCode"]
        action = payment_response["action"]
        session[:payment_data] = payment_response["paymentData"]
        puts ('displaying payment_response')
        puts (payment_response)
        if action
            render json: { action: action, resultCode: result_code }   
        else
            render json: { resultCode: result_code }
        end     
    end


    def make_payment(payment_method)
        response = adyen.checkout.payments({
          :amount => {
            :currency => "EUR",
            :value => 1000
          },
          :shopperIP => request.remote_ip,
          :channel => "Web",
          :reference => "subha_checkoutchallenge",
          :additionalData => {
            :executeThreeD => "true"
          },
          :returnUrl => "http://localhost:3000/api/handleRedirect",
          :merchantAccount => "SupportRecruitementCOM",
          :paymentMethod => payment_method,
        })
        response
    end


    def handle_redirect
      payload = {}
      payload["details"] = params
      payload["paymentData"] = session[:payment_data]
      puts ('displaying redirect payload')
      puts (payload)
      paymentresponse = adyen.checkout.payments.details(payload)
      resp = paymentresponse.response
      session[:payment_data] = ""
      puts (resp)
    
        case resp["resultCode"]
          when "Authorised"
            redirect_to '/success'
          when "Pending"
            redirect_to '/pending'
          when "Refused"
            redirect_to '/failed'
          else
            redirect_to '/error'
        end
    end

    def adyen
        adyen = Adyen::Client.new
        adyen.env = :test
        adyen.api_key = "AQE1hmfxKo3NaxZDw0m/n3Q5qf3Ve55dHZxYTFdTxWq+l3JOk8J4BO7yyZBJ4o0JviXqoc8j9sYQwV1bDb7kfNy1WIxIIkxgBw==-q7XjkkN/Cud0WELZF+AzXpp/PuCB8+XmcdgqHYUWzTA=-Kk9N4dG837tIyjZF"
        adyen
    end


end

