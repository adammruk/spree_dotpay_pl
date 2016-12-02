Spree::Core::Engine.routes.draw do

  post '/dotpay_pl/webhooks/notification' => 'dotpay_webhook#notification'

  post '/dotpay_pl/webhooks/redirect_to_order/:number' => 'dotpay_webhook#redirect_to_order'
end
