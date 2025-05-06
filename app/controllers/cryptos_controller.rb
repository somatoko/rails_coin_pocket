# frozen_string_literal: true

require './lib/coinmarketcap'

# Everything related to the users's coin portfolio.
class CryptosController < ApplicationController
  before_action :set_crypto, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[ show edit update destroy ]

  # GET /cryptos or /cryptos.json
  def index
    @portfolio_coins = Crypto.where(user: current_user)
    @portfolio_list = Coinmarketcap::CoinInfo.obtain_coin_info @portfolio_coins
    puts @portfolio_list
  end

  # GET /cryptos/1 or /cryptos/1.json
  def show; end

  # GET /cryptos/new
  def new
    @crypto = Crypto.new
  end

  # GET /cryptos/1/edit
  def edit; end

  # POST /cryptos or /cryptos.json
  def create
    @crypto = Crypto.new(crypto_params)
    @crypto.user = current_user

    respond_to do |format|
      if @crypto.save
        format.html { redirect_to @crypto, notice: "Crypto was successfully created." }
        format.json { render :show, status: :created, location: @crypto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cryptos/1 or /cryptos/1.json
  def update
    respond_to do |format|
      if @crypto.update(crypto_params)
        format.html { redirect_to @crypto, notice: "Crypto was successfully updated." }
        format.json { render :show, status: :ok, location: @crypto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crypto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cryptos/1 or /cryptos/1.json
  def destroy
    @crypto.destroy!

    respond_to do |format|
      format.html { redirect_to cryptos_path, status: :see_other, notice: "Crypto was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  def set_crypto
    @crypto = Crypto.find(params[:id])
  end

  def crypto_params
    params.require(:crypto).permit(:symbol, :user_id_id, :cost_per, :amount_owned)
  end

  # Only allow to users see their own coins.
  def correct_user
    @correct = current_user.cryptos.find_by(id: params[:id])
    redirect_to cryptos_url, notice: 'Not allowed' if @correct.nil?
  end
end
