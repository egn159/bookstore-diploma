require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'Orders controller' do

    let(:user) { FactoryGirl.create(:user) }
    let(:coupon) { FactoryGirl.create(:coupon, code: "testcoupon")}

    context 'GET #index' do
      context 'without cart items' do
        before(:each) do
          sign_in user
          @order = FactoryGirl.create(:order, user: user)
          get :index
        end

        it 'select necessary order' do
          expect(assigns(:cart)).to eq(@order)
        end

        it 'open cart' do
          expect(response).to have_http_status(:ok)
        end

        it 'render cart page' do
          expect(response).to render_template('index')
        end

        it 'check cart is empty' do
          expect(assigns(:cart).order_items.count).to eq 0
        end

        it 'check cart isn\'t empty' do
          cart = assigns(:cart)
          order_item = FactoryGirl.create(:order_item, book: FactoryGirl.create(:book))
          cart.order_items << order_item
          cart.save
          get :index
          expect(assigns(:cart).order_items.count).not_to eq 0
        end
      end

      context 'with cart items' do
        before(:each) do
          sign_in user
          @order = FactoryGirl.create(:order, :with_books, user: user)
          get :index
        end

        it 'check cart isn\'t empty' do
          expect(assigns(:cart).order_items.count).not_to eq 0
        end
      end
    end

    context 'POST #activate_coupon' do
      context 'with empty cart' do
        before(:each) do
          sign_in user
          @order = FactoryGirl.create(:order, user: user)
        end

        it 'try to activate and something happening' do
          post :activate_coupon, params: { order: { coupon_id: coupon.code } }
          expect(flash[:notice]).not_to be nil
        end

        it 'check that I cannot use coupon to empty cart' do
          post :activate_coupon, params: { order: { coupon_id: coupon.code } }
          expect(flash[:notice]).to eq I18n.t('coupon.cantactivate')
        end
      end

      context 'with cart items' do
        before(:each) do
          sign_in user
          @order = FactoryGirl.create(:order, :with_books, user: user)
        end

        it 'show activate success' do
          post :activate_coupon, params: { order: { coupon_id: coupon.code } }
          expect(flash[:notice]).to eq I18n.t('coupon.activatesuccess')
        end

        it 'check that coupon have effect to order sum' do
          post :activate_coupon, params: { order: { coupon_id: coupon.code } }
          expect(assigns(:order).coupon_discount).to eq coupon.discount
        end

        it 'try activate expired coupon' do
          expired_coupon = FactoryGirl.create(:coupon, code: "testcoupon2", expires: DateTime.now - 5.days)
          post :activate_coupon, params: { order: { coupon_id: expired_coupon.code } }
          expect(flash[:notice]).to eq I18n.t('coupon.termerror')
        end

        it 'show that order sum is not enough' do
          coupon = FactoryGirl.create(:coupon, min_sum_to_activate: @order.subtotal + 1)
          post :activate_coupon, params: { order: { coupon_id: coupon.code } }
          expect(flash[:notice]).to eq I18n.t('coupon.sumerror')
        end

        it 'show that coupon is not exist' do
          some_rand_value = "----nasdfjan213sd"
          post :activate_coupon, params: { order: { coupon_id: some_rand_value } }
          expect(flash[:notice]).to eq I18n.t('coupon.noexist')
        end
      end
    end
  end
end
