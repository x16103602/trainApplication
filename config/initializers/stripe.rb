Rails.configuration.stripe = {
  :publishable_key => Rails.application.secrets.Stripe_Publishable_key,
  :secret_key      => Rails.application.secrets.Stripe_Secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]