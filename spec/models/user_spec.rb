require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @params = {
      first_name: 'Tautrion',
      last_name: 'Stoneglutes',
      email: 'goddess-king@petalsworn.clan',
      email_confirmation: 'goddess-king@petalsworn.clan',
      password: 'flowerDeity96',
      password_confirmation: 'flowerDeity96'
    }
  end

  describe 'validations:' do
    it 'should succeed when all parameters/confirmations are valid/present' do
      user = User.create @params
      expect(user).to be_valid
    end

    describe 'password' do
      it 'should require both password and password_confirmation' do
        user = User.create @params.except(:password_confirmation)
        expect(user.errors.full_messages)
          .to include "Password confirmation can't be blank"
        user = User.create @params.except(:password)
        expect(user.errors.full_messages)
          .to include "Password can't be blank"
      end
      it 'should require that password and password_confirmation match' do
        @params[:password] = 'banana'
        user = User.create @params
        expect(user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end
      it 'should require that the password be more than 5 characters long' do
        @params[:password] = @params[:password_confirmation] = 'bloop'
        user = User.create @params
        expect(user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
    end

    describe 'email' do
      it 'should require a unique email' do
        user1 = User.create @params
        user2 = User.create @params
        expect(user2.errors.full_messages).to include "Email has already been taken"
      end
      it 'should require both email and email_confirmation' do
        user = User.create @params.except(:email_confirmation)
        expect(user.errors.full_messages).to include "Email confirmation can't be blank"
        user = User.create @params.except(:email)
        expect(user.errors.full_messages).to include "Email confirmation doesn't match Email"
      end
      it 'should require that email and email_confirmation match' do
        @params[:email] = 'bloodwarrior@hemoclobberin.clan'
        user = User.create @params
        expect(user.errors.full_messages).to include "Email confirmation doesn't match Email"
      end
    end

    describe 'names' do
      it 'should require first_name' do
        user = User.create @params.except(:first_name)
        expect(user.errors.full_messages).to include "First name can't be blank"
      end
      it 'should require last_name' do
        user = User.create @params.except(:last_name)
        expect(user.errors.full_messages).to include "Last name can't be blank"
      end
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should return an instance of the user if successfully authenticated' do
      @user = User.create(@params)
      auth_user = User.authenticate_with_credentials(@params[:email], @params[:password])
      expect(auth_user.email).to eq @user.email
    end
    it 'should authenticate properly regardless of leading/trailing whitespace' do
      @user = User.create(@params)
      @params[:email] = "   #{@params[:email]}  "
      auth_user = User.authenticate_with_credentials(@params[:email], @params[:password])
      expect(auth_user.email).to eq @user.email
    end
    it 'should authenticate properly regardless of email case' do
      @params[:email] = @params[:email_confirmation] = "TeSt@tEst.COm"
      @user = User.create(@params)
      auth_user = User.authenticate_with_credentials("tEST@TeST.coM", @params[:password])
      expect(auth_user.email).to eq @user.email
    end
    it 'should return nil if authentication is unsuccessful' do
      @user = User.create(@params)
      auth_user = User.authenticate_with_credentials(@params[:email], 'banana')
      expect(auth_user).to be_nil
    end
    it 'should return nil if the user does not exist' do
      @user = User.create(@params)
      auth_user = User.authenticate_with_credentials('test@test.test', 'banana')
      expect(auth_user).to be_nil
    end
  end
end