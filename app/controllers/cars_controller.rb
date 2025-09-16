class CarsController < ApplicationController
  def show
    @car = Car.first # Since we only have one car
    redirect_to root_path unless @car
  end
end
