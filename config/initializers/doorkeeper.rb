Doorkeeper.configure do

  orm :active_record

  resource_owner_authenticator do
    current_user || warden.authenticate!(:scope => :user)
  end

  admin_authenticator do
    user = current_user || warden.authenticate!(:scope => :user)
    user.role.downcase == "manager" ? true : redirect_to(root_url,:notice=>'Access denied')
  end
end
