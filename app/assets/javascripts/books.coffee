# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "turbolinks:load", ->
  $("a[data-remote]").on("ajax:success", (e, data, status, xhr) ->
    console.log('loaded')
    ).on "ajax:error", (e, xhr, status, error) ->
     console.log('ERROR')

  $('.rating_bar').starRating({
    starSize: 25,
    initialRating: 1,
    useFullStars: true,
    disableAfterRate: false,
    callback: (currentRating, $el) ->
      $('[name="review[rating]"]').val(currentRating)
  })

  $(".egn_book_cart .item-change-quantity").click (event) ->
    action = $(this).data('action')

    if action != null
      current_quantity = parseInt($(".egn_book_cart .quantity-input").val())

      if isNaN(current_quantity) || current_quantity < 1
        $(".egn_book_cart .quantity-input").val("1")
        return

      if action == "minus"
        return if current_quantity == 1
        current_quantity--
      else
        current_quantity++

      $(".egn_book_cart .quantity-input").val(current_quantity)

    event.preventDefault()


  $(".egn-read-more").click (event) ->
    $(this).hide()
    $('.full_txt_dots').hide()
    $('.full_txt').show()

