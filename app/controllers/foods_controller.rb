class FoodsController < ApplicationController
  before_action :set_food, only: %i[ show edit update destroy ]

  # GET /foods or /foods.json
  def index
    @foods = Food.all
  end

  # GET /foods/1 or /foods/1.json
  def show
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods or /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to food_url(@food), notice: "Food was successfully created." }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1 or /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to food_url(@food), notice: "Food was successfully updated." }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1 or /foods/1.json
  def destroy
    @food.destroy

    respond_to do |format|
      format.html { redirect_to foods_url, notice: "Food was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # add add 1 unit of food
  def add_1
    @food = Food.find(params[:id])
    @food.quantity = @food.quantity + 1
    @food.save
    redirect_to @food
  end

  # remove add 1 unit of food
  def remove_1
    @food = Food.find(params[:id])
    @food.quantity = @food.quantity - 1
    @food.save
    redirect_to @food
  end

  def add
    @food = Food.find(params[:id])
    @food.quantity = @food.quantity + params[:add].to_f
    @food.quantity = @food.quantity - params[:remove].to_f
    @food.save
    redirect_to @food
  end

  def changes
    @food = Food.find(params[:id])
    @audits = @food.audits
    array = Array.new(@audits.size) do |i|
      if (@audits[i].audited_changes["quantity"].class == Float)
        {"quantity" => @audits[i].audited_changes["quantity"], "updated_at" => @audits[i].audited_changes["updated_at"][-1].to_s[0..9]}
      elsif (@audits[i].audited_changes["quantity"] == nil)
        next
      else
        {"quantity" => @audits[i].audited_changes["quantity"][-1] - @audits[i].audited_changes["quantity"][0] + @audits[i-1].audited_changes["quantity"][-1], "updated_at" => @audits[i].audited_changes["updated_at"][-1].to_s[0..9]}
        #{"quantity" => @audits[i].audited_changes["quantity"][-1] - @audits[i-1].audited_changes["quantity"][-1], "updated_at" => @audits[i].audited_changes["updated_at"][-1].to_s[0..9]}
      end
    end
    df = array.group_by { |hash| hash["updated_at"] }.map do |_k, values| 
      values.reduce({}) do |a, e| 
        a.merge(e) do |key, old_val, new_val| 
          key == "quantity" ? old_val += new_val : old_val
        end
      end
    end
    @chartkick_hash = {} 
    df.each do |hash|
      @chartkick_hash[hash["updated_at"]] = hash["quantity"]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def food_params
      params.require(:food).permit(:name, :description, :quantity, :spoilage)
      #params.permit(:food, :name, :description, :quantity, :spoilage)
    end
end
