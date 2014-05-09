# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $ ->
#   return if typeof Stripe == "undefined" #returns error if the part doesn't need stripe
#   Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"))

#   $(document).on "submit", "#new_bid", ->
#     $("input[type=submit]").attr("disabled", true)
#     if $("#bid_card_number").length
#       processCard()
#       false



# processCard = ->
#   card = 
#     number: $("#bid_card_number").val()
#     cvc:  $("#bid_cvc").val()
#     expMonth: $("#bid_card_month_2i").val()
#     expYear: $("#bid_card_year_1i").val()

#   Stripe.createToken(card, handleStripeResponse)

# handleStripeResponse = (status,response) ->
#   if status == 200
#     $("#bid_card_number").val("")
#     $("#bid_cvc").val("")
#     $("#bid_card_month_2i").val("")
#     $("#bid_card_year_1i").val("")
#     $("#bid_stripe_card_token").val(response.id)
#     $("#new_bid")[0].submit()
#   else
#     $("#stripe-error").text(response.error.message)
#     $("input[type=submit]").attr("disabled", false).val("submit")