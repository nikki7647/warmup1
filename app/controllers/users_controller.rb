class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  #=================================warm up 1=====================================
  #POST /users/login
  def add
	if params[:user] == '' or params[:user].length > 128
		@result = -3
	elsif User.find_by_user(params[:user])
		@result = -2
	elsif params[:password].length > 128
		@result = -4
	else
		@new = User.create(:user => params[:user], :password => params[:password], :count => 1)
		@result = 1
	end
	
	if @result >= 1
		render :json => { 'errCode' => 1, 'count' => @result }
	else
		render :json => { 'errCode' => @result }
	end
	
  end
  
  #POST /users/add
  def login
	@user = User.find_by_user(params[:user])
	if not @user
		@result = -1
	elsif not @user.password == params[:password]
		@result = -1
	else
		@user.count = @user.count + 1
		@user.save
		@result = @user.count
	end
	
	if @result >= 1
		render :json => { 'errCode' => 1, 'count' => @result }
	else
		render :json => { 'errCode' => @result }
	end
  end
  
  #POST /TESTAPI/resetFixture
  def resetFixture
	User.delete_all
	render :json => { 'errCode' => 1}
  end
  
  #POST /TESTAPI/unitTests
  def unitTests
	@unit_test_output = %x(ruby -Itest test/unit/user_test.rb)
	@results = ''
    @unit_test_output.each_line do |li|
      if (li[/^[0-9]+ tests.*/])
        @results = li
        break
      end
    end
    /[0-9]+ tests/ =~ @results
    /[0-9]+/ =~ Regexp.last_match[0]
    @total_tests = Regexp.last_match[0].to_i
    # @total_tests = 0
    /[0-9]+ failures/ =~ @results
    /[0-9]+/ =~ Regexp.last_match[0]
    @failures = Regexp.last_match[0].to_i
    # @failures = 0
    render :json => { 'totalTests' => @total_tests, 'nrFailed' => @failures, 'output' => @unit_test_output }
	#render :json => { 'totalTests' => 11, 'nrFailed' => 0, 'output' => 'This is a fake response' }
  end
  #================================================================================

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:user, :password, :count)
    end
end
